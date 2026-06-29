{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # Limit number of boot entries (nix generations, it's annoying)
  boot.loader.systemd-boot.configurationLimit = 5;

  # Enable Amd microcode updates
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Enable BIOS updates
  services.fwupd.enable = true;

  # Disable power-profiles-daemon (conflicts with auto-cpufreq)
  services.power-profiles-daemon.enable = false;

  # Power saving and management
  services.auto-cpufreq.enable = true;
  services.auto-cpufreq.settings = {
    battery = {
      governor = "powersave";
      turbo = "never";
    };
    charger = {
      governor = "performance";
      turbo = "auto";
    };
  };

  # Enable graphics
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Lid close settings
  services.logind.settings.Login = {
    HandleLidSwitch = "suspend-then-hibernate";
    HandleLidSwitchExternalPower = "suspend";
    HandleLidSwitchDocked = "ignore";
  };

  # Enable fingerprint reader
  services.fprintd.enable = true;

  # Configure PAM for fingerprint authentication
  security.pam.services = {
    sudo.fprintAuth = true; # Enable fingerprint for sudo
    su.fprintAuth = true; # Enable fingerprint for su
    "gdm-password".fprintAuth = true; # Enable fingerprint for GNOME login
    "gdm-fingerprint".fprintAuth = true; # Enable fingerprint for GNOME login
    login.fprintAuth = false; # Keep for login
  };

  # Enable flakes
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Allow editors/tools to run downloaded generic Linux binaries, such as
  # Zed external agents, which expect /lib64/ld-linux-x86-64.so.2 to exist.
  programs.nix-ld.enable = true;

  # Enable garbage collection
  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 7d";
    persistent = true; # Run on next boot if timer was missed
  };

  # Enable auto upgrade from my github repo
  system.autoUpgrade = {
    enable = true;
    allowReboot = false;
    dates = "daily";
    randomizedDelaySec = "1h";
    flake = "github:1Solon/framework-13-nixos";
    persistent = true; # Run on next boot if timer was missed
  };

  # Enable store optimization
  nix.optimise.automatic = true;

  # Enable networking
  networking.networkmanager.enable = true;
  networking.hostName = "sauls-laptop";
  networking.hosts = {
    "192.168.1.111" = [ "TrueNAS" ];
  };

  # Enable Tailscale VPN
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client";
  };

  # Enable geolocation services for location-aware desktop features.
  services.geoclue2.enable = true;
  services.geoclue2.whitelistedAgents = lib.mkForce [ "geoclue-demo-agent" ];

  # Set time zone automatically based on location.
  services.automatic-timezoned.enable = true;
  systemd.services.automatic-timezoned.serviceConfig = {
    Restart = "on-failure";
    RestartSec = "30s";
  };

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IE.UTF-8";
    LC_IDENTIFICATION = "en_IE.UTF-8";
    LC_MEASUREMENT = "en_IE.UTF-8";
    LC_MONETARY = "en_IE.UTF-8";
    LC_NAME = "en_IE.UTF-8";
    LC_NUMERIC = "en_IE.UTF-8";
    LC_PAPER = "en_IE.UTF-8";
    LC_TELEPHONE = "en_IE.UTF-8";
    LC_TIME = "en_IE.UTF-8";
  };

  # Enable GNOME.
  services.xserver.enable = true;
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Keep Chromium/Electron and Mozilla apps on the native Wayland path.
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";
    MOZ_ENABLE_WAYLAND = "1";
  };

  # Configure console keymap
  console.keyMap = "uk";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  # See: https://community.frame.work/t/microphone-not-working-after-nixos-update/74915
  services.pipewire.wireplumber.extraConfig.no-ucm = {
    "monitor.alsa.properties" = {
      "alsa.use-ucm" = false;
    };
  };

  # Enable audio enhancement for Framework Laptop 13
  hardware.framework.laptop13.audioEnhancement.rawDeviceName =
    lib.mkDefault "alsa_output.pci-0000_c1_00.6.analog-stereo";

  # Enable XDG Desktop Portal for screen/audio sharing in browsers (Wayland/GNOME).
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
  };

  # Define a user account. Don't forget to set a password with 'passwd'.
  users.users.saul = {
    isNormalUser = true;
    description = "Saul Burgess";
    extraGroups = [
      "audio"
      "networkmanager"
      "wheel"
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable zsh
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # Global packages, used by all users
  environment.systemPackages = with pkgs; [
    git
    nfs-utils
    tailscale
    trayscale
    wget
  ];

  # Zen / 1Password stuff
  # 1Password configuration for Zen Browser
  environment.etc = {
    "1password/custom_allowed_browsers" = {
      text = ''
        .zen-wrapped
      ''; # or just "zen" if you use unwrapped package
      mode = "0644";
    };
  };

  # Enable steam
  programs.steam = {
    enable = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  # Enable 1password
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "saul" ];
  };

  # Enable logitech
  hardware.logitech.wireless.enable = true;
  hardware.logitech.wireless.enableGraphical = true;

  # Enable docker
  virtualisation.docker.enable = true;

  system.stateVersion = "25.05";
}
