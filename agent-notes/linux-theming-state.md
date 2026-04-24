# Linux Theming State — frankie (Hyprland/Wayland)

## Quick Reference

| Layer | Tool | Theme/Value | Config |
|---|---|---|---|
| Qt5 widgets | qt5ct | Adwaita-Dark + darker colors | `~/.config/qt5ct/qt5ct.conf` |
| Qt5 icons | qt5ct | Papirus-Dark | `~/.config/qt5ct/qt5ct.conf` |
| Qt6 widgets | qt6ct | Kvantum (MateriaDark) + darker colors | `~/.config/qt6ct/qt6ct.conf` |
| Qt6 icons | qt6ct | Papirus-Dark-Maia | `~/.config/qt6ct/qt6ct.conf` |
| Kvantum | kvantum | MateriaDark | `~/.config/Kvantum/kvantum.kvconfig` |
| GTK3 | settings.ini | Materia-dark | `~/.config/gtk-3.0/settings.ini` |
| GTK4/libadwaita | gsettings | Materia-dark + prefer-dark | `dconf: org.gnome.desktop.interface` |
| Icons (gsettings) | gsettings | Papirus-Dark | `dconf: org.gnome.desktop.interface` |
| Icons (KDE Frameworks) | kdeglobals | Papirus-Dark | `~/.config/kdeglobals [Icons]` |
| KDE color scheme | hyprland env | MateriaDark.colors | `KDE_COLOR_SCHEME_PATH` env |
| Cursor | hyprland env | size=24 | `XCURSOR_SIZE`, `HYPRCURSOR_SIZE` |

## Platform Theme Resolution

**Global:** `QT_QPA_PLATFORMTHEME=xdgdesktopportal` (hyprland.conf)
- Overrides `qt5ct` from `~/.profile` and `/etc/environment`
- Portal backend: `xdg-desktop-portal-gtk` → reads gsettings
- Works for Qt6/Kirigami apps (EasyEffects etc.)
- **Broken for Qt5/KDE Frameworks** — can't resolve icon theme thru portal-gtk

**Per-app overrides:**
- Krita: `QT_QPA_PLATFORMTHEME=qt5ct` via `~/.local/share/applications/org.kde.krita.desktop`

**Legacy env (set but overridden by hyprland):**
- `~/.profile`: `QT_QPA_PLATFORMTHEME=qt5ct`
- `/etc/environment`: `QT_QPA_PLATFORMTHEME=qt5ct`

## Hyprland Env Block

```
env = XCURSOR_SIZE,24
env = HYPRCURSOR_SIZE,24
env = QT_QPA_PLATFORMTHEME,xdgdesktopportal
env = KDE_COLOR_SCHEME_PATH,/usr/share/color-schemes/MateriaDark.colors
```

## Portal Stack

| Portal | Version | Role |
|---|---|---|
| `xdg-desktop-portal` | 1.20.3 | Core |
| `xdg-desktop-portal-hyprland` | 1.3.11 | Screenshot/ScreenCast/GlobalShortcuts only |
| `xdg-desktop-portal-gtk` | 1.15.3 | Settings, FileChooser, fallback |
| `xdg-desktop-portal-gnome` | 49.0 | — |
| `xdg-desktop-portal-cosmic` | 1.0.8 | — |
| `xdg-desktop-portal-kde` | ❌ not installed | Would fix Qt5/KDE icon resolution, pulls Plasma deps |

Portal pref: `~/.config/xdg-desktop-portal/portals.conf` → `default=hyprland;gtk`

## Known Issues & Workarounds

### Qt5 apps can't get icon theme from xdgdesktopportal
- portal-gtk serves gsettings but Qt5 xdgdesktopportal plugin won't apply to KDE Frameworks KIconTheme
- **Fix:** per-app desktop override with `QT_QPA_PLATFORMTHEME=qt5ct`
- Applied to: Krita
- When Krita ports Qt6 → remove override, global xdgdesktopportal handles it

### GTK3 icon theme mismatch
- `~/.config/gtk-3.0/settings.ini` → `gtk-icon-theme-name=Adwaita`
- gsettings → `icon-theme='Papirus-Dark'`
- Most GTK3 apps read gsettings via portal → Papirus-Dark wins in practice

### EasyEffects dark theme (fixed af9201bc)
- EasyEffects 8.x = Qt6/Kirigami, NOT GTK4
- Needs `QT_QPA_PLATFORMTHEME=xdgdesktopportal` + `KDE_COLOR_SCHEME_PATH`
- qt6ct color scheme was `airy.conf` (light) → changed to `darker.conf`

## Session History

- **af9201bc** (2026-04-23): Fix EasyEffects dark theme. `QT_QPA_PLATFORMTHEME`: `qt5ct` → `qt6ct` → `xdgdesktopportal`. Add `KDE_COLOR_SCHEME_PATH`.
- **c53a50b5** (2026-04-24): Fix Krita folder icons. Add `[Icons] Theme=Papirus-Dark` to kdeglobals (not enough alone). Create per-app desktop override for Krita with `qt5ct`.
