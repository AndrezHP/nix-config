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
      email = { };
      cloudflare-api-key = { };
      nextcloudAdminPassword = { };
      initialHashedPassword = { };
      gluetunEnv = { };
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

  baseDomain = "zetmuse.xyz";
  services.caddy.enable = true;
  networking.firewall.allowedUDPPorts = [ config.services.tailscale.port ];
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
    initialHashedPassword = config.sops.secrets.initialHashedPassword.path;
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
    fzf
    lshw
    zip
    unzip
    yazi
    ripgrep
    sops
    nmap

    eza # better ls?
    zoxide # better file path navigation
    lazygit
    neofetch

    # Mounting flash drives and other harddrives
    usbutils
    udisks
    udiskie # Removable disk automounter for udisks
    efibootmgr # Efi boot manager

    networkmanagerapplet
    libva # Implementation of VA-API (Video acceleration)
  ];

  fonts.packages = with pkgs; [ jetbrains-mono ];

  system.stateVersion = "23.11";
}
