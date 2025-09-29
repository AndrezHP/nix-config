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
    ./hardware-configuration.nix
    ../../modules/homelab
  ];

  sops = {
    defaultSopsFile = ../../secrets/secrets.json;
    defaultSopsFormat = "json";
    age = {
      sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      keyFile = "/var/lib/sops-nix/key.txt";
      generateKey = true;
    };
    secrets = {
      cloudflare-api-token = { };
      nextcloudAdminPassword = { };
      gluetunEnv = { };
      sambaPassword = { };
    };
  };

  services.tailscale = {
    enable = true;
    useRoutingFeatures = "both";
    extraUpFlags = [
      "--advertise-exit-node"
      "--advertise-routes=192.168.1.0/24"
      "--accept-routes"
    ];
  };

  baseDomain = "test.zetmuse.xyz";
  services.caddy.enable = true;
  networking.firewall.allowedUDPPorts = [ config.services.tailscale.port ];
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
  homelab = {
    networkInterface = "enp3s0";
    jellyfin.enable = true;
    samba.enable = true;
    immich.enable = true;
    homepage.enable = true;
    uptime-kuma.enable = true;
    microbin.enable = true;
    vaultwarden.enable = true;
    audiobookshelf.enable = true;
    jellyseerr.enable = true;
    nextcloud.enable = true;

    radarr.enable = true;
    sonarr.enable = true;
    prowlarr.enable = true;
    lidarr.enable = true;
    bazarr.enable = true;
    sabnzbd.enable = true;
    deluge.enable = true;
  };

  networking.interfaces."enp3s0".wakeOnLan = {
    enable = true;
    policy = [ "magic" ];
  };

  ### Config for ZFS with 
  # zpool create -O atime=off -O compression=on -O mountpoint=none -O xattr=sa -O acltype=posixacl -o ashift=12 vol0 raidz1 /dev/sda /dev/sdb /dev/sdc /dev/sdd
  # Encryption option with: -O encryption=on -O keyformat=passphrase -O keylocation=prompt 
  networking.hostId = "deadcafe";
  boot = {
    supportedFilesystems = [ "zfs" ];
    zfs.extraPools = [ "vol0" ];
  };
  services.zfs = {
    autoScrub = {
      enable = true;
      interval = "monthly";
      pools = [ "vol0 "];
    };
    autoSnapshot.enable = true;
  };
  fileSystems = {
    "/mnt/media" = {
      device = "vol0/media";
      fsType = "zfs";
    };
    "/mnt/backup" = {
      device = "vol0/backup";
      fsType = "zfs";
    };
  };

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

  # Enable OpenGL
  hardware.graphics.enable = true;
  nix.settings = {
    auto-optimise-store = true;
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  networking.hostName = "nixos-server";
  networking.networkmanager.enable = true;
  time.timeZone = "Europe/Copenhagen";
  i18n.defaultLocale = "en_DK.UTF-8";

  users.users.andreas = {
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "podman"
    ];
  };

  environment.shells = with pkgs; [ zsh ];
  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;

  systemd.services.udp-gro-forwarding = {
    description = "Improve UPD throughput using transport layer offloads";
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = ''
        ${pkgs.bash}/bin/bash -c '
          NETDEV=$(ip -o route get 8.8.8.8 | cut -f 5 -d " ")
          ${pkgs.ethtool}/bin/ethtool -K $NETDEV rx-udp-gro-forwarding on rx-gro-list off
        '
      '';
    };
  };

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    neovim
    htop
    git
    fzf # what all the fuzz is about
    lshw
    zip
    unzip
    yazi
    ripgrep
    sops
    nmap
    kitty
    zfs #

    eza # better ls?
    zoxide # better file path navigation
    lazygit # when magit can't reach your destination
    tealdeer # ain't nobody got time for reading man
    neofetch # pseudo-flex

    # Mounting flash drives and other harddrives
    usbutils
    udisks
    udiskie # Removable disk automounter for udisks
    efibootmgr # Efi boot manager

    networkmanagerapplet
    libva # Implementation of VA-API (Video acceleration)
  ];

  fonts.packages = with pkgs; [ jetbrains-mono ];

  # home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.andreas = import ./home.nix;

  system.stateVersion = "25.05";
}
