{ config, pkgs, ... }:

{
  services.swaync = {
    enable = true;

    style = (builtins.readFile ../colors.css) + (builtins.readFile ./style.css);

    settings = {
      positionX = "left";
      positionY = "bottom";
      layer = "overlay";
      control-center-layer = "top";
      layer-shell = true;
      cssPriority = "user";
      control-center-width = 350;
      control-center-margin-top = 8;
      control-center-margin-bottom = 8;
      control-center-margin-right = 0;
      control-center-margin-left = 8;
      notification-2fa-action = true;
      notification-inline-replies = true;
      notification-window-width = 350;
      notification-icon-size = 60;
      notification-body-image-height = 180;
      notification-body-image-width = 180;
      timeout = 12;
      timeout-low = 6;
      timeout-critical = 1;
      fit-to-screen = true;
      keyboard-shortcuts = true;
      image-visibility = "when available";
      transition-time = 200;
      hide-on-clear = false;
      hide-on-action = true;
      script-fail-notify = true;

      widgets = [
        "mpris"
        "title"
        "notifications"
        "volume"
        "backlight"
        "buttons-grid"
      ];

      widget-config = {
        title = {
          text = "Notification Center";
          clear-all-button = true;
          button-text = "󰆴";
        };

        label = {
          max-lines = 1;
          text = "Notification Center!";
        };

        mpris = {
          image-size = 80;
          image-radius = 0;
        };

        volume = {
          label = "󰕾 ";
        };

        backlight = {
          label = "󰃟 ";
          device = "amdgpu_bl1";
        };

        buttons-grid = {
          actions = [
            {
              label = "󰝟";
              command = ''wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle'';
              type = "toggle";
            }
            {
              label = "󰍭";
              command = ''wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle'';
              type = "toggle";
            }
            {
              label = "󰍜";
              command = "hyprlock";
            }
            {
              label = "󰜉";
              command = "reboot";
            }
            {
              label = "󰐥";
              command = "shutdown now";
            }
          ];
        };
      };
    };
  };
}
