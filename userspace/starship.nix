{ ... }:

{
  # Starship prompt configuration
  programs.starship = {
    enable = true;
    settings = {
      command_timeout = 500;
      scan_timeout = 10;
      format = "$directory$git_branch$git_status$nix_shell$line_break$character";
    };
  };

  home.sessionVariables = {
    STARSHIP_LOG = "error";
  };
}
