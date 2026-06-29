{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:

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
    inputs.zen-browser.homeModules.beta
  ];

  dconf.settings."org/gnome/desktop/interface" = {
    cursor-theme = "Adwaita";
    icon-theme = "Adwaita";
    gtk-theme = "Adwaita";
  };

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
    playwright

    # Office
    libreoffice
    hunspell
    hunspellDicts.en_GB-large

    # Communication
    (discord.override {
      commandLineArgs = "--force-device-scale-factor=1.2 --gtk-version=4 --enable-features=WaylandWindowDecorations,WaylandPerSurfaceScale,WaylandUiScale";
    })
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
}
