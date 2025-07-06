{ lib, config, ... }:
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
    ./audiobookshelf.nix
    ./jellyseerr.nix
    ./nextcloud.nix
  ];

  options.baseDomain = lib.mkOption {
    default = "";
    type = lib.types.str;
    description = "Base domain to be used for subdomains in reverse proxy";
  };

  # config = {
  #   security.acme = {
  #     acceptTerms = true;
  #     defaults.email = "andreas1990klo@hotmail.com";
  #     certs.${config.baseDomain} = {
  #       reloadServices = [ "caddy.service" ];
  #       domain = "${config.baseDomain}";
  #       extraDomainNames = [ "*.${config.baseDomain}" ];
  #       dnsProvider = "namecheap";
  #       dnsResolver = "1.1.1.1:53";
  #       dnsPropagationCheck = true;
  #       group = config.services.caddy.group;
  #     };
  #   };
  # };
}
