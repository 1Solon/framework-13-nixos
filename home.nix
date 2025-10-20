{
  config,
  pkgs,
  inputs,
  ...
}:

{
  home.username = "saul";
  home.homeDirectory = "/home/saul";
  home.stateVersion = "25.05";
  programs.home-manager.enable = true;

  imports = [
    # Subfile imports
    ./programs/zen.nix
    ./programs/git.nix
    ./programs/github-cli.nix
    ./programs/zsh.nix
    ./programs/starship.nix
    ./programs/alacritty.nix
    ./programs/vscode.nix
    ./hyprland/hyprland.nix
    ./hyprland/wofi/config.nix

    # External imports
    inputs.zen-browser.homeModules.beta
  ];

  home.packages = with pkgs; [
    # Editors
    # vscode is now managed via programs/vscode.nix

    # Version control
    git
    gh

    # Security & secrets
    sops

    # Kubernetes & cluster tooling
    k9s
    kubectl
    talosctl

    # Containers
    docker
    docker-compose

    # Shell & prompt
    zsh
    zsh-autocomplete
    starship
    tmux

    # Languages & toolchains
    cue
    go
    python3
    nodejs

    # Build & task runners
    go-task
    gnumake
    nixfmt-rfc-style

    # System utilities
    xdg-utils
    logiops
    btop
    htop
    gcr

    # Tools
    ferdium
    nautilus

    # Office
    libreoffice-qt
    hunspell
    hunspellDicts.en_GB-large

    # Communication
    discord
    thunderbird
    teams-for-linux

    # Fonts
    monaspace

    # Hyprland dependencies
    grim
    slurp
    wl-clipboard
    swaynotificationcenter
    libnotify
    wofi
    fastfetch
    blueman
    hyprcursor

  ];

  # Enable gnome keyring for managing secrets
  services.gnome-keyring.enable = true;

  # Enable dark theme for GTK applications
  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
  };

  # Configure cursor theme for Wayland/Hyprland
  home.pointerCursor = {
    name = "Bibata-Modern-Classic";
    package = pkgs.bibata-cursors;
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  # Set dark theme preference for GNOME applications
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "Adwaita-dark";
    };
  };
}
