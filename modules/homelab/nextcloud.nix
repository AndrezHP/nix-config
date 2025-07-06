{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.homelab.next;
  port = 8083;
in
{
  options.homelab.nextcloud = {
    enable = lib.mkEnableOption "Enable Nextcloud";
    category = lib.mkOption {
      type = lib.types.str;
      default = "Media";
    };
    homepage = lib.mkOption {
      type = lib.types.attrs;
      default = {
        name = "Nextcloud";
        icon = "nextcloud.svg";
        description = "Self-hosted photo and video management";
        href = "http://cloud.${config.baseDomain}";
        siteMonitor = "http://127.0.0.1:${toString port}";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.nginx = {
      enable = true;
      recommendedTlsSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      virtualHosts."cloud.${config.baseDomain}" = {
        forceSSL = true;
        enableACME = true;
      };
      virtualHosts."onlyoffice.${config.baseDomain}" = {
        forceSSL = true;
        enableACME = true;
      };
    };

    systemd.services."nextcloud-setup" = {
      requires = [ "postgresql.service" ];
      after = [ "postgresql.service" ];
    };

    services.nextcloud = {
      enable = true;
      package = pkgs.nextcloud30;
      hostName = "cloud.${config.baseDomain}";
      maxUploadSize = "20G";
      https = true;
      autoUpdateApps.enable = true;
      database.createLocally = true;
      configureRedis = true;

      extraApps = with config.services.nextcloud.package.packages.apps; {
        inherit calendar contacts mail;
        inherit notes onlyoffice tasks;
      };

      config = {
        dbtype = "pgsql";
        overwriteProtocol = "https";
        adminuser = "admin";
        # TODO use sops
        # adminpassFile = "use-sops";
      };
    };

    services.onlyoffice = {
      enable = true;
      hostname = "onlyoffice.${config.baseDomain}";
    };
  };
}
