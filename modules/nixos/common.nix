# Settings shared by every host. Not imported anywhere yet: import it from a
# host's configuration.nix, then delete the duplicated settings from that host.
{ pkgs, lib, ... }:
let
  sshKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL0Y2pKiFLlDTQ5nEs4sJFfhG03qIQde2PXVpLtyuKcj andreas@nixos";
in
{
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
      trusted-users = [
        "root"
        "@wheel"
      ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };
  nixpkgs.config.allowUnfree = true;

  # Keep /boot from filling up with old generations
  boot.loader.grub.configurationLimit = lib.mkDefault 10;

  time.timeZone = lib.mkDefault "Europe/Copenhagen";
  i18n.defaultLocale = lib.mkDefault "en_DK.UTF-8";
  networking.networkmanager.enable = lib.mkDefault true;

  programs.zsh.enable = true;
  environment.shells = [ pkgs.zsh ];
  users.defaultUserShell = pkgs.zsh;

  # Hosts add their own extraGroups (docker, share, ...); lists merge
  users.users.andreas = {
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    openssh.authorizedKeys.keys = [ sshKey ];
  };
  users.users.root.openssh.authorizedKeys.keys = [ sshKey ];

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "prohibit-password";
    };
  };

  # Hosts that use secrets still declare their own sops.secrets
  sops = {
    defaultSopsFile = ../../secrets/secrets.json;
    defaultSopsFormat = "json";
    age = {
      sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      keyFile = "/var/lib/sops-nix/key.txt";
      generateKey = true;
    };
  };

  environment.systemPackages = with pkgs; [
    neovim
    git
    btop
    fzf
    ripgrep
    lshw
    zip
    unzip
    curl
    wget
    sops
    usbutils
    udisks
    udiskie
    efibootmgr
  ];
}
