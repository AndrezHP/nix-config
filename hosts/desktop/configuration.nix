{ config, pkgs, ... }:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../nixosModules/displayserver.nix
    ../../nixosModules/kanata/kanata.nix
  ];

  nixosModules.displayServer.wayland = {
    enable = true;
    hyprland.enable = true;
  };
  nixosModules.kanata.enable = true;

  # Bootloader.
  boot.loader = {
    grub = {
      enable = true;
      device = "nodev";
      useOSProber = true;
      efiSupport = true;
      fsIdentifier = "uuid";
    };
    efi.canTouchEfiVariables = true;
  };

  # Enable OpenGL
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [ nvidia-vaapi-driver ];
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = [ "nvidia" ];
  # Nvidia driver options
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    prime = {
      sync.enable = true;
      nvidiaBusId = "PCI:10:0:0";
      intelBusId = "PCI:0:0:0";
    };
  };

  hardware.logitech.wireless.enable = true;
  hardware.bluetooth.enable = true;
  hardware.cpu.amd.updateMicrocode = true;
  boot.kernelParams = [
    "amd_pstate=active"
  ];
  powerManagement.cpuFreqGovernor = "performance";

  environment.variables.PATH = [ "$XDG_CONFIG_HOME/emacs/bin" ];
  environment.sessionVariables = {
    # If your cursor becomes invisible
    WLR_NO_HARDWARE_CURSORS = "1";
    # Some other settings
    GBM_BACKEND = "nvidia-drm";
    LIBVA_DRIVER_NAME = "nvidia";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    MOZ_ENABLE_WAYLAND = 1;
    GDK_BACKEND = "wayland";
  };

  # Automatic garbage collection of old generations
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # Setup desktop extra harddisks and windows partition
  boot.supportedFilesystems = [ "ntfs" ];
  fileSystems = {
    "/mnt/disk1" = {
      device = "/dev/disk/by-uuid/CA367026367015A3";
      fsType = "ntfs-3g";
      options = [ "nofail" ];
    };
    "/mnt/disk2" = {
      device = "/dev/disk/by-uuid/5AD4EDF9D4EDD6F3";
      fsType = "ntfs-3g";
      options = [ "nofail" ];
    };
    "/mnt/windowsPartition" = {
      device = "/dev/disk/by-uuid/5A78427D784257C1";
      fsType = "ntfs-3g";
      options = [ "nofail" ];
    };
  };

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    auto-optimise-store = true;
  };
  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Copenhagen";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_DK.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "da_DK.UTF-8";
    LC_IDENTIFICATION = "da_DK.UTF-8";
    LC_MEASUREMENT = "da_DK.UTF-8";
    LC_MONETARY = "da_DK.UTF-8";
    LC_NAME = "da_DK.UTF-8";
    LC_NUMERIC = "da_DK.UTF-8";
    LC_PAPER = "da_DK.UTF-8";
    LC_TELEPHONE = "da_DK.UTF-8";
    LC_TIME = "da_DK.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    # Configure keymap in X11
    xkb.layout = "us";
    xkb.variant = "";
  };
  programs.dconf.enable = true;

  security.rtkit.enable = true;

  services.libinput.enable = true;
  services.printing.enable = true;
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users = {
    andreas = {
      isNormalUser = true;
      description = "Andreas";
      extraGroups = [
        "networkmanager"
        "wheel"
        "docker"
      ];
    };
  };

  # Allow running executables
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Add any missing dynamic libraries for unpackaged
    # programs here, NOT in environment.systemPackages
  ];

  programs.noisetorch.enable = true;
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  services.devmon.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  # Use zsh as default shell (configured with home-manager)
  programs.zsh.enable = true;
  environment.shells = with pkgs; [ zsh ];
  users.defaultUserShell = pkgs.zsh;

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    neovim
    htop
    git
    lf # Terminal file manager
    mpv # Video player
    fzf # Fuzzy finder
    lshw # List hardware
    wireplumber # PipeWire session/policy manager
    zip
    unzip
    lm_sensors # Hardware temp sensor

    rustup

    # Mounting flash drives and other harddrives
    usbutils
    udiskie
    udisks
    efibootmgr

    dunst # Notification daemon
    libnotify # Notification daemon depends on this
    networkmanagerapplet

    libva # Implementation of VA-API (Video acceleration)
    xdg-desktop-portal-gtk

    kitty # Hyprland default terminal

    # For nvidia compatibility
    vulkan-loader
    vulkan-validation-layers
    vulkan-tools
  ];

  xdg.portal.enable = true;
  xdg.portal.config.common.default = "*";
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-emoji
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.iosevka
    liberation_ttf
    inconsolata
    jetbrains-mono
    font-awesome
    dejavu_fonts
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true; # Network diagnostics
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
