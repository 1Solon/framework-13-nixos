{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:

let
  winsurKdeTheme = inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.winsur-kde-theme;
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
    opencode
    opencode-desktop

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
    winsurKdeTheme
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

  programs.plasma = {
    enable = true;
    workspace = {
      lookAndFeel = "com.github.yeyushengfan258.WinSur-dark";
      theme = "WinSur-dark";
      colorScheme = "WinSurDark";
      widgetStyle = "kvantum";
      wallpaper = "${winsurKdeTheme}/share/wallpapers/WinSur-dark/contents/images/2560x1440.png";
    };
  };
}
