import argparse
import contextlib
import hashlib
import importlib.machinery
import importlib.util
import io
from pathlib import Path
import subprocess
import tempfile
import unittest
from unittest import mock


loader = importlib.machinery.SourceFileLoader(
    "brew_safe_upgrade", str(Path(__file__).with_name("brew-safe-upgrade"))
)
spec = importlib.util.spec_from_loader(loader.name, loader)
upgrade = importlib.util.module_from_spec(spec)
loader.exec_module(upgrade)


class YabaiUpgradeTests(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.addCleanup(self.tmp.cleanup)
        self.binary = Path(self.tmp.name) / "yabai"
        self.binary.write_bytes(b"old binary")
        self.args = argparse.Namespace(packages=[], dry_run=False)
        self.output = io.StringIO()
        self.enterContext(contextlib.redirect_stdout(self.output))
        self.enterContext(mock.patch.object(upgrade, "YABAI_BINARY", self.binary))
        self.refresh = self.enterContext(mock.patch.object(upgrade, "refresh_yabai"))

    def process(self, packages, *, kind="formula", changed=False, returncode=0):
        def run(cmd, **kwargs):
            if cmd[1] == "outdated":
                return subprocess.CompletedProcess(cmd, 0, "\n".join(packages), "")
            return subprocess.CompletedProcess(cmd, 1, "", "")

        def execute(cmd, **kwargs):
            if changed:
                self.binary.write_bytes(b"new binary")
            return subprocess.CompletedProcess(cmd, returncode)

        with mock.patch.object(upgrade, "run", side_effect=run):
            with mock.patch.object(upgrade.subprocess, "run", side_effect=execute) as executed:
                result = upgrade.process_kind(kind, self.args, {})
                return result, executed

    def test_changed_yabai_refreshes_using_new_digest(self):
        result, _ = self.process(["yabai"], changed=True)
        self.assertEqual(result, 1)
        self.refresh.assert_called_once_with(hashlib.sha256(b"new binary").hexdigest())

    def test_qualified_formula_name_refreshes(self):
        self.process(["asmvik/formulae/yabai"], changed=True)
        self.refresh.assert_called_once()

    def test_unchanged_binary_skips_refresh(self):
        self.process(["yabai"])
        self.refresh.assert_not_called()

    def test_unrelated_formula_skips_refresh(self):
        self.process(["fish"], changed=True)
        self.refresh.assert_not_called()

    def test_cask_skips_refresh(self):
        self.process(["yabai"], kind="cask", changed=True)
        self.refresh.assert_not_called()

    def test_dry_run_does_not_read_binary_or_run_commands(self):
        self.args.dry_run = True
        self.binary.unlink()
        _, executed = self.process(["yabai"])
        executed.assert_not_called()
        self.refresh.assert_not_called()
        self.assertIn("would refresh yabai", self.output.getvalue())

    def test_partial_failed_upgrade_still_refreshes_changed_yabai(self):
        with self.assertRaises(subprocess.CalledProcessError):
            self.process(["fish", "yabai"], changed=True, returncode=1)
        self.refresh.assert_called_once()

    def test_failed_upgrade_without_change_does_not_refresh(self):
        with self.assertRaises(subprocess.CalledProcessError):
            self.process(["yabai"], returncode=1)
        self.refresh.assert_not_called()

    def test_refresh_failure_is_not_swallowed(self):
        self.refresh.side_effect = subprocess.CalledProcessError(1, ["sudo"])
        with self.assertRaises(subprocess.CalledProcessError):
            self.process(["yabai"], changed=True)


class YabaiRefreshTests(unittest.TestCase):
    def setUp(self):
        self.output = io.StringIO()
        self.enterContext(contextlib.redirect_stdout(self.output))
        self.enterContext(mock.patch.object(upgrade.pwd, "getpwuid", return_value=mock.Mock(pw_name="testuser")))
        self.enterContext(mock.patch.object(upgrade.os, "getuid", return_value=501))
        self.query = self.enterContext(mock.patch.object(upgrade, "run"))
        self.query.side_effect = lambda cmd, **kwargs: subprocess.CompletedProcess(
            cmd, 0 if cmd[-1].endswith("com.koekeishiya.yabai") else 1, "", ""
        )
        self.rule = None

    def execute(self, cmd, **kwargs):
        if cmd[0] == "/usr/sbin/visudo":
            self.rule = Path(cmd[-1]).read_text()
        return subprocess.CompletedProcess(cmd, 0)

    def test_validates_before_install_and_restarts_legacy_service(self):
        with mock.patch.object(upgrade.subprocess, "run", side_effect=self.execute) as execute:
            upgrade.refresh_yabai("a" * 64)
        self.assertEqual(
            self.rule,
            f"testuser ALL=(root) NOPASSWD: sha256:{'a' * 64} {upgrade.YABAI_BINARY} --load-sa\n",
        )
        commands = [call.args[0] for call in execute.call_args_list]
        self.assertEqual(commands[0][:2], ["/usr/sbin/visudo", "-cf"])
        self.assertEqual(commands[1][0:9], [
            "sudo", "/usr/bin/install", "-S", "-o", "root", "-g", "wheel", "-m", "440",
        ])
        self.assertEqual(commands[1][-1], str(upgrade.YABAI_SUDOERS))
        self.assertEqual(commands[2], ["sudo", "-n", str(upgrade.YABAI_BINARY), "--load-sa"])
        self.assertEqual(commands[3], [
            "launchctl", "kickstart", "-k", "gui/501/com.koekeishiya.yabai",
        ])

    def test_current_service_label_is_supported(self):
        self.query.side_effect = lambda cmd, **kwargs: subprocess.CompletedProcess(cmd, 0)
        with mock.patch.object(upgrade.subprocess, "run", side_effect=self.execute) as execute:
            upgrade.refresh_yabai("a" * 64)
        self.assertEqual(execute.call_args.args[0][-1], "gui/501/com.asmvik.yabai")
        self.query.assert_called_once()

    def test_invalid_rule_is_never_installed(self):
        with mock.patch.object(upgrade.subprocess, "run") as execute:
            execute.side_effect = subprocess.CalledProcessError(1, ["visudo"])
            with self.assertRaises(subprocess.CalledProcessError):
                upgrade.refresh_yabai("a" * 64)
        execute.assert_called_once()
        self.query.assert_not_called()

    def test_install_failure_prevents_reload(self):
        def execute(cmd, **kwargs):
            if cmd[0] == "sudo":
                raise subprocess.CalledProcessError(1, cmd)
            return self.execute(cmd, **kwargs)

        with mock.patch.object(upgrade.subprocess, "run", side_effect=execute) as executed:
            with self.assertRaises(subprocess.CalledProcessError):
                upgrade.refresh_yabai("a" * 64)
        self.assertEqual(executed.call_count, 2)
        self.query.assert_not_called()

    def test_load_failure_still_restarts_service_but_is_reported(self):
        def execute(cmd, **kwargs):
            if "--load-sa" in cmd:
                return subprocess.CompletedProcess(cmd, 1)
            return self.execute(cmd, **kwargs)

        with mock.patch.object(upgrade.subprocess, "run", side_effect=execute) as executed:
            with self.assertRaises(subprocess.CalledProcessError):
                upgrade.refresh_yabai("a" * 64)
        self.assertEqual(executed.call_args.args[0][0:3], ["launchctl", "kickstart", "-k"])
        self.assertNotIn("scripting addition refreshed.", self.output.getvalue())

    def test_stopped_service_is_not_started(self):
        self.query.side_effect = lambda cmd, **kwargs: subprocess.CompletedProcess(cmd, 1)
        with mock.patch.object(upgrade.subprocess, "run", side_effect=self.execute) as execute:
            upgrade.refresh_yabai("a" * 64)
        self.assertEqual(execute.call_count, 3)
        self.assertIn("leaving services unchanged", self.output.getvalue())


class UpgradeFailureTests(unittest.TestCase):
    def test_failed_refresh_restores_taps_and_returns_failure(self):
        output = io.StringIO()
        errors = io.StringIO()
        with contextlib.redirect_stdout(output), contextlib.redirect_stderr(errors):
            with (
                mock.patch.object(upgrade.sys, "argv", ["brew-safe-upgrade", "--formulas-only"]),
                mock.patch.object(upgrade, "setup_official_tap", return_value=("abc", "2026-10-01", True)),
                mock.patch.object(upgrade, "find_thirdparty_taps", return_value=[]),
                mock.patch.object(upgrade, "process_kind", side_effect=subprocess.CalledProcessError(
                    1, ["sudo", "-n", "/opt/homebrew/bin/yabai", "--load-sa"],
                )),
                mock.patch.object(upgrade, "teardown_official_tap") as restore,
            ):
                self.assertEqual(upgrade.main(), 1)
        restore.assert_called_once_with("homebrew/core", True)
        self.assertIn("post-upgrade refresh failed", errors.getvalue())
        self.assertNotIn("Upgraded:", output.getvalue())


if __name__ == "__main__":
    unittest.main()
