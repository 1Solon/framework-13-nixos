{
  config,
  pkgs,
  inputs,
  ...
}:

let
  ottoKdeTheme = inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.otto-kde-theme;
in
{
  home.username = "saul";
  home.homeDirectory = "/home/saul";
  home.stateVersion = "25.05";
  programs.home-manager.enable = true;

  imports = [
    # Subfile imports
    ./userspace/zen.nix
    ./userspace/git.nix
    ./userspace/github-cli.nix
    ./userspace/zsh.nix
    ./userspace/starship.nix
    ./userspace/alacritty.nix

    # External imports
    inputs.plasma-manager.homeModules.plasma-manager
    inputs.zen-browser.homeModules.beta
  ];

  home.packages = with pkgs; [
    # Editors
    zed-editor

    # Version control
    git
    gh

    # Security & secrets
    sops

    # Kubernetes & cluster tooling
    k9s
    kubectl
    talosctl
    fluxcd
    cilium-cli

    # Containers
    docker
    docker-compose

    # Shell & prompt
    zsh
    zsh-autocomplete
    starship
    tmux
    codex

    # Languages & toolchains
    cue
    go
    python3
    nodejs

    # Build & task runners
    go-task
    gnumake
    nil
    nixd
    nixfmt

    # System utilities
    xdg-utils
    logiops
    btop
    htop
    gcr
    unzip

    # Tools
    chromium
    ferdium
    kdePackages.dolphin
    kdePackages.gwenview
    kdePackages.qtstyleplugin-kvantum
    libsForQt5.qtstyleplugin-kvantum
    ottoKdeTheme
    playwright

    # Office
    libreoffice
    hunspell
    hunspellDicts.en_GB-large

    # Communication
    discord
    thunderbird
    teams-for-linux

    # Fonts
    monaspace

    # Utilities
    fastfetch
    blueman

    # Games
    starsector

  ];

  # Align GTK applications with KDE Plasma.
  gtk = {
    enable = true;
    theme = {
      name = "Breeze-Dark";
      package = pkgs.kdePackages.breeze-gtk;
    };
    iconTheme = {
      name = "breeze-dark";
      package = pkgs.kdePackages.breeze-icons;
    };
    gtk4.theme = config.gtk.theme;
  };

  qt = {
    enable = true;
    platformTheme.name = "kde";
    style.name = "kvantum";
  };

  programs.plasma = {
    enable = true;
    workspace = {
      lookAndFeel = "Otto";
      theme = "Otto";
      colorScheme = "Otto";
      widgetStyle = "kvantum";
      wallpaper = "${ottoKdeTheme}/share/wallpapers/Otto/contents/images/3840x2160.png";
    };
  };

  xdg.configFile."Kvantum/kvantum.kvconfig".text = ''
    [General]
    theme=Otto
  '';

  # Configure cursor theme for Wayland.
  home.pointerCursor = {
    name = "Bibata-Modern-Classic";
    package = pkgs.bibata-cursors;
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

}
