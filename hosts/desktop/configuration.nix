{
  config,
  pkgs,
  modulesPath,
  ...
}:
{
  imports = [
    # (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")
    ./hardware-configuration.nix
    ../../modules/nixos
  ];

  sops = {
    defaultSopsFile = ../../secrets/secrets.json;
    defaultSopsFormat = "json";
    age = {
      sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      keyFile = "/var/lib/sops-nix/key.txt";
      generateKey = true;
    };
    secrets.sambaCredentials = { };
  };
  environment.etc."smb-credentials".source = config.sops.secrets.sambaCredentials.path;

  nixosModules.kanata.enable = true;
  nixosModules.desktops.hyprland.enable = true;
  nixosModules.ollama.enable = true;
  nixosModules.virtualization = {
    enable = true;
    user = "andreas";
  };
  virtualisation.docker.enable = true;
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "both";
  };

  # Bootloader.
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    useOSProber = true;
    efiSupport = true;
    fsIdentifier = "uuid";
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
    package = config.boot.kernelPackages.nvidiaPackages.beta;
    prime = {
      sync.enable = true;
      nvidiaBusId = "PCI:10:0:0";
      intelBusId = "PCI:0:0:0";
    };
  };

  # AMD stuff
  hardware.cpu.amd.updateMicrocode = true;
  boot.kernelParams = [
    "amd_pstate=active"
  ];
  powerManagement.cpuFreqGovernor = "performance";

  hardware.logitech.wireless.enable = true;
  hardware.bluetooth.enable = true;

  environment.variables.PATH = [ "$XDG_CONFIG_HOME/emacs/bin" ];
  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
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
  nix.optimise.automatic = true;
  nix.optimise.dates = [ "weekly" ];
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    auto-optimise-store = true;
  };

  # Setup desktop extra harddisks and windows partition
  boot.supportedFilesystems = [ "ntfs" ];
  fileSystems =
    let
      options = [
        "nofail"
        "rw"
        "uid=1000"
        "gid=1000"
        "umask=022"
        "x-systemd.device-timeout=10"
      ];
    in
    {
      "/mnt/disk1" = {
        device = "/dev/disk/by-uuid/CA367026367015A3";
        fsType = "ntfs-3g";
        inherit options;
      };
      "/mnt/disk2" = {
        device = "/dev/disk/by-uuid/5AD4EDF9D4EDD6F3";
        fsType = "ntfs-3g";
        inherit options;
      };
      "/mnt/windowsPartition" = {
        device = "/dev/disk/by-uuid/5A78427D784257C1";
        fsType = "ntfs-3g";
        inherit options;
      };
    };

  networking.hostName = "nixos-desktop";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Copenhagen";
  i18n.defaultLocale = "en_DK.UTF-8";

  services.xserver = {
    enable = true;
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
  users.defaultUserShell = pkgs.zsh;

  nixpkgs.config.allowUnfree = true;
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = [ ];

  programs.noisetorch.enable = true;
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  services.devmon.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  programs.zsh.enable = true;
  environment.shells = with pkgs; [ zsh ];

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
    kitty # Hyprland default terminal
    sops

    # Mounting flash drives and other harddrives
    usbutils
    udiskie
    udisks
    efibootmgr
    ntfs3g
    fuse3

    dunst # Notification daemon
    libnotify # Notification daemon depends on this
    networkmanagerapplet
    xdg-desktop-portal-gtk

    # For nvidia compatibility
    vulkan-loader
    vulkan-validation-layers
    vulkan-tools
    libva # Implementation of VA-API (Video acceleration)
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
    jetbrains-mono
    font-awesome
  ];

  programs.mtr.enable = true; # Network diagnostics
  services.openssh.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  system.stateVersion = "23.11";
}
