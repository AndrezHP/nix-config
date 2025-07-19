{
  lib,
  pkgs,
  config,
  ...
}:
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
    ./vaultwarden.nix
    ./audiobookshelf.nix
    ./jellyseerr.nix
    ./nextcloud.nix
    ./sabnzbd.nix
    ./deluge.nix
  ];

  options.baseDomain = lib.mkOption {
    default = "";
    type = lib.types.str;
    description = "Base domain to be used for subdomains in reverse proxy";
  };

  config = {
    security.acme = {
      acceptTerms = true;
      defaults.email = "andreas1990klo@hotmail.com";
      certs.${config.baseDomain} = {
        reloadServices = [ "caddy.service" ];
        domain = "${config.baseDomain}";
        extraDomainNames = [ "*.${config.baseDomain}" ];
        dnsProvider = "cloudflare";
        dnsResolver = "1.1.1.1:53";
        dnsPropagationCheck = true;
        environmentFile = "${pkgs.writeText "cloudflare-credentials" ''
          CLOUDFLARE_EMAIL=${config.sops.secrets.email.path}
          CLOUDFLARE_API_KEY=${config.sops.secrets.cloudflare-api-key.path}
        ''}";
        group = config.services.caddy.group;
      };
    };

    services.caddy = {
      enable = true;
      globalConfig = ''
        auto_https off
      '';
      virtualHosts = {
        "http://${config.baseDomain}" = {
          extraConfig = ''
            redir https://{host}{uri}
          '';
        };
        "http://*.${config.baseDomain}" = {
          extraConfig = ''
            redir https://{host}{uri}
          '';
        };
      };
    };
  };
}
