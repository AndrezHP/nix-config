{ ... }:
{
  imports = [
    ./samba.nix
    ./jellyfin.nix
    ./immich.nix
    ./homepage.nix
    ./uptime-kuma.nix
    ./microbin.nix
    ./radarr.nix
    ./sonarr.nix
    ./prowlarr.nix
    ./lidarr.nix
    ./bazarr.nix
    ./adguard-home.nix
    ./vaultwarden.nix
  ];
}
