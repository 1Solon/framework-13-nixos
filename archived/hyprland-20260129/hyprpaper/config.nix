{ config, ... }:
{
  # Hyprpaper for wallpapers
  services.hyprpaper.enable = true;

  services.hyprpaper.settings =
    let
      wallpaperDir = "${config.home.homeDirectory}/Pictures/Wallpapers";
    in
    {
      ipc = false;
      splash = false;

      preload = [
        "${wallpaperDir}/progress.jpg"
      ];

      wallpaper = [
        ",${wallpaperDir}/progress.jpg"
      ];
    };
}
