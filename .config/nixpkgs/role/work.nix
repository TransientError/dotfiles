{
  programs.git = {
    userEmail = "wukevin@microsoft.com";
    extraConfig = { credential."dev.azure.com".useHttpPath = true; };
  };
}
