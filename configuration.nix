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
    /etc/nixos/hardware-configuration.nix
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
    sddm.fprintAuth = false; # Keep for SDDM
    login.fprintAuth = false; # Keep for login
  };

  # Enable flakes
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

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
    flags = [ "--impure" ];
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

  # Enable geolocation services for GNOME
  services.geoclue2.enable = true;

  # Set time zone. (automatically!)
  services.automatic-timezoned.enable = true;

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

  # Enable GDM Display Manager for GNOME
  services.displayManager.gdm.enable = true;
  services.displayManager.gdm.wayland = true;

  # Enable GNOME
  services.xserver.enable = true;
  services.desktopManager.gnome.enable = true;

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

  # Enable XDG Desktop Portal for screen/audio sharing in browsers (Wayland/GNOME)
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gnome
      xdg-desktop-portal-gtk
    ];
    config.common.default = "*";
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
    packages = with pkgs; [ ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Home Manager
  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
  home-manager.backupFileExtension = "backup";

  # Enable zsh
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # Global packages, used by all users
  environment.systemPackages = with pkgs; [
    git
    nfs-utils
    tailscale
    trayscale
    vscode
    wget
  ];

  # Zen / 1Password stuff
  # 1Password configuration for Zen Browser
  environment.etc = {
    "1password/custom_allowed_browsers" = {
      text = ''
        .zen-wrapped
      ''; # or just "zen" if you use unwrapped package
      mode = "0755";
    };
  };

  # Mount NFS shares from TrueNAS
  fileSystems."/home/saul/nfs" = {
    device = "192.168.1.111:/mnt/STORAGE-01/Media-Storage";
    fsType = "nfs";
    options = [
      "x-systemd.automount"
      "noauto"
    ];
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
