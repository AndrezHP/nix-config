{ lib, ... }:
{
  options.baseDomain = lib.mkOption {
    default = "";
    type = lib.types.str;
    description = "Base domain to be used for subdomains in reverse proxy";
  };
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
    ./audiobookshelf.nix
    ./jellyseerr.nix
    ./nextcloud.nix
  ];
}
