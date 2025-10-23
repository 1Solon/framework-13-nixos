{ ... }: {
  # Git configuration
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "1Solon";
        email = "Solonerus@gmail.com";
      };
      "protocol.https".allow = "always";
      "push".autoSetupRemote = true;
      "init".defaultBranch = "main";
    };
  };
}