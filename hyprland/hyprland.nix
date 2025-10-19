{ config, pkgs, ... }:
let
  mod = "SUPER";
in
{
  imports = [
    ./waybar/config.nix
    ./swaync/config.nix
    ./hyprpaper/config.nix
  ];

  # Enable Hyprland via Home Manager
  wayland.windowManager.hyprland = {
    enable = true;
    package = pkgs.hyprland;
    xwayland.enable = true;

    settings = {
      "$mod" = mod;

      # Auto-detect monitor and scale
      monitor = [ ",preferred,auto,2" ];

      # Makes everything use the wayland backend where possible
      env = [
        "NIXOS_OZONE_WL,1"
        "MOZ_ENABLE_WAYLAND,1"
        "QT_QPA_PLATFORM,wayland"
        "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
        "GDK_BACKEND,wayland,x11"
        "MOZ_ENABLE_WAYLAND=1"
        "ELECTRON_OZONE_PLATFORM_HINT,wayland"
        "HYPRCURSOR_THEME,Bibata-Modern-Classic"
        "HYPRCURSOR_SIZE,20"
      ];

      general = {
        gaps_in = 2;
        gaps_out = 10;
        border_size = 0; # no border
        "col.active_border" = "rgba(c0c0c0ff)"; # silver
        "col.inactive_border" = "rgba(3a3d42cc)"; # muted
        resize_on_border = true;
        allow_tearing = false;
        layout = "dwindle";
      };

      decoration = {
        rounding = 10;
        active_opacity = 0.9;
        inactive_opacity = 0.7;
        fullscreen_opacity = 1;
        blur = {
          enabled = true;
          size = 3;
          passes = 5;
          new_optimizations = true;
          ignore_opacity = true;
          xray = false;
          popups = true;
        };
        shadow = {
          enabled = true;
          range = 15;
          render_power = 5;
          color = "rgba(0,0,0,0.35)";
        };
      };

      animations = {
        enabled = true;
        bezier = [
          "fluid, 0.15, 0.85, 0.25, 1"
          "snappy, 0.3, 1, 0.4, 1"
        ];
        animation = [
          "windows, 1, 3, fluid, popin 5%"
          "windowsOut, 1, 2.5, snappy"
          "fade, 1, 4, snappy"
          "workspaces, 1, 1.7, snappy, slide"
          "specialWorkspace, 1, 4, fluid, slidefadevert -35%"
          "layers, 1, 2, snappy, popin 70%"
        ];
      };

      dwindle = {
        preserve_split = true;
      };

      misc = {
        force_default_wallpaper = -1;
        disable_hyprland_logo = true;
        focus_on_activate = false;
      };

      cursor = {
        no_hardware_cursors = false;
        enable_hyprcursor = true;
      };

      # Autostart
      exec-once = [
        "waybar"
        "swaync"
        "hyprctl setcursor Bibata-Modern-Classic 24"

        "sh -c 'mkdir -p \"$HOME\"/Pictures/screenshots'"
        "sh -c 'mkdir -p \"$HOME\"/Pictures/Wallpapers'"

        # Startup apps
        "[workspace special:ferdium silent] ferdium"
        "[workspace special:thunderbird silent] thunderbird"

        # Tray apps
        "trayscale --hide-window"
      ];

      input = {
        kb_layout = "gb";
        follow_mouse = 1;
        sensitivity = 0;
        touchpad = {
          natural_scroll = true;
          scroll_factor = 0.3;
        };
      };

      # Touchpad gestures
      gesture = [
        # 3-finger horizontal swipe to switch workspaces
        "3, horizontal, workspace"
        
        # 3-finger swipe up to toggle fullscreen
        "3, up, fullscreen"
      ];

      # Keybindings
      bind = [
        # Terminal
        "${mod}, Q, exec, alacritty"

        # App launcher
        "${mod}, R, exec, wofi --show drun"

        # Window controls
        "${mod}, M, exit,"
        "${mod}, C, killactive,"
        "${mod}, F, fullscreen, 0"
        "${mod}, V, togglefloating,"

        # Workspaces 1..10 (0 maps to 10)
        "${mod}, 1, workspace, 1"
        "${mod}, 2, workspace, 2"
        "${mod}, 3, workspace, 3"
        "${mod}, 4, workspace, 4"
        "${mod}, 5, workspace, 5"
        "${mod}, 6, workspace, 6"
        "${mod}, 7, workspace, 7"
        "${mod}, 8, workspace, 8"
        "${mod}, 9, workspace, 9"
        "${mod}, 0, workspace, 10"

        # Toggle special workspace with Ferdium
        "ALT, X, togglespecialworkspace, ferdium"
        "ALT, M, togglespecialworkspace, thunderbird"

        # Move focused window to workspace 1..10
        "${mod} SHIFT, 1, movetoworkspace, 1"
        "${mod} SHIFT, 2, movetoworkspace, 2"
        "${mod} SHIFT, 3, movetoworkspace, 3"
        "${mod} SHIFT, 4, movetoworkspace, 4"
        "${mod} SHIFT, 5, movetoworkspace, 5"
        "${mod} SHIFT, 6, movetoworkspace, 6"
        "${mod} SHIFT, 7, movetoworkspace, 7"
        "${mod} SHIFT, 8, movetoworkspace, 8"
        "${mod} SHIFT, 9, movetoworkspace, 9"
        "${mod} SHIFT, 0, movetoworkspace, 10"

        # Screenshots
        ", Print, exec, sh -c 'REGION=$(slurp) || exit; grim -g \"$REGION\" - | wl-copy && wl-paste > ~/Pictures/screenshots/Screenshot-$(date +%F_%T).png && dunstify \"Screenshot of the region taken\" -t 1000'"
        "SHIFT, Print, exec, sh -c 'grim - | wl-copy && wl-paste > ~/Pictures/screenshots/Screenshot-$(date +%F_%T).png && dunstify \"Screenshot of the whole screen taken\" -t 1000'"

        # Volume controls
        ''${mod}, XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ && dunstify "Volume: $(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2*100)}')%" -t 1000''
        ''${mod}, XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- && dunstify "Volume: $(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2*100)}')%" -t 1000''
        ''${mod}, XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle && dunstify "$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q MUTED && echo 'Muted' || echo 'Unmuted')" -t 1000''

        # Brightness controls
        ''${mod}, XF86MonBrightnessUp, exec, brightnessctl set 5%+ && dunstify "Brightness: $(brightnessctl -m info | cut -d, -f4)" -t 1000''
        ''${mod}, XF86MonBrightnessDown, exec, brightnessctl set 5%- && dunstify "Brightness: $(brightnessctl -m info | cut -d, -f4)" -t 1000''
      ];

      # Mouse bindings
      bindm = [
        "${mod}, mouse:272, movewindow"
        "${mod}, mouse:273, resizewindow"
      ];
    };
  };
}
