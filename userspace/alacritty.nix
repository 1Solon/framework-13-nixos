{ ... }: {
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        opacity = 0.9;
        padding = {
          x = 5;
          y = 5;
        };
      };
      
      font = {
        normal = {
          family = "Monaspace Neon";
          style = "Regular";
        };
        size = 11.0;
      };
    };
  };
}
