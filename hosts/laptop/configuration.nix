{
  config,
  pkgs,
  modulesPath,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disko.nix
    ../../modules/nixos/desktops
    ../../modules/homelab
  ];

  baseDomain = "zetmuse.xyz";
  services.caddy.enable = true;
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
  homelab = {
    jellyfin.enable = true;
    samba.enable = true;
    immich.enable = true;
    homepage.enable = true;
    uptime-kuma.enable = true;
    microbin.enable = true;
    adguard-home.enable = false;
    vaultwarden.enable = true;
    audiobookshelf.enable = true;
    jellyseerr.enable = true;
    nextcloud.enable = true;

    radarr.enable = true;
    sonarr.enable = true;
    prowlarr.enable = true;
    lidarr.enable = true;
    bazarr.enable = true;
  };

  networking.interfaces."enp2s0f1".wakeOnLan = {
    enable = true;
    policy = [ "magic" ];
  };

  # Disable sleep on closing the lid
  services.logind.lidSwitch = "ignore";

  nixosModules.desktops.hyprland.enable = true;

  # Bootloader.
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    efiInstallAsRemovable = true;
    fsIdentifier = "uuid";
  };

  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL0Y2pKiFLlDTQ5nEs4sJFfhG03qIQde2PXVpLtyuKcj andreas@nixos"
  ];

  services.devmon.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  # Enable OpenGL
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [ nvidia-vaapi-driver ];
  };

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    nvidiaSettings = true;
    open = false;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    auto-optimise-store = true;
  };
  networking.hostName = "nixos-laptop";
  networking.networkmanager.enable = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  time.timeZone = "Europe/Copenhagen";
  i18n.defaultLocale = "en_DK.UTF-8";

  services.xserver = {
    enable = true;
    xkb.layout = "us";
    xkb.variant = "";
  };

  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1"; # If your cursor becomes invisible
    NIXOS_OZONE_WL = "1"; # Make electron apps use wayland
  };

  hardware.bluetooth.enable = true;
  services.libinput.enable = true;
  services.printing.enable = true;
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users = {
    andreas = {
      isNormalUser = true;
      initialHashedPassword = "$6$xoEF5OVlxv7YpVnA$Ewy6xAOhQ.tFH5coFUJfCWRAA3EHxbgFJ2Xyp2mnaHTzfkSej2yA.Qpw2kxi5tUCKJ.cnQqmoZBaXOVm1nClG0";
      extraGroups = [
        "networkmanager"
        "wheel"
        "docker"
        "podman"
      ];
      packages = with pkgs; [
        firefox
      ];
    };
  };

  nixpkgs.config.allowUnfree = true;
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [ ];

  environment.shells = with pkgs; [ zsh ];
  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
    gitMinimal
    neovim
    htop
    # git
    mpv
    fzf
    lshw
    wireplumber
    zip
    unzip
    lf
    curl
    kitty
    ripgrep

    # Mounting flash drives and other harddrives
    usbutils
    udisks
    udiskie # Removable disk automounter for udisks
    efibootmgr # Efi boot manager

    dunst # Notification daemon
    libnotify # Notification daemon depends on this
    networkmanagerapplet
    libva # Implementation of VA-API (Video acceleration)
    xdg-desktop-portal-gtk
  ];

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    jetbrains-mono
  ];

  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  system.stateVersion = "23.11";
}
