{ ... }:
{
  programs.wofi = {
    enable = true;
    settings = {
      allow_images = true;
      width = 500;
      show = "drun";
      prompt = "Search";
      height = 400;
      term = "alacritty";
      hide_scroll = true;
      print_command = true;
      insensitive = true;
      columns = 1;
      no_actions = true;
    };
    style = (builtins.readFile ../colors.css) + (builtins.readFile ./style.css);
  };
}
