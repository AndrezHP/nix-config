{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.homelab.nextcloud;
  port = 8083;
in
{
  options.homelab.nextcloud = {
    enable = lib.mkEnableOption "Enable Nextcloud";
    category = lib.mkOption {
      type = lib.types.str;
      default = "Services";
    };
    homepage = lib.mkOption {
      type = lib.types.attrs;
      default = {
        name = "Nextcloud";
        icon = "nextcloud.svg";
        description = "Self-hosted cloud things";
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
      virtualHosts."cloud.${config.baseDomain}" = {
        forceSSL = true;
        enableACME = true;
        listen = [
          {
            addr = "127.0.0.1";
            port = port;
          }
        ];
      };
    };

    # Datebase things
    systemd.services."nextcloud-setup" = {
      requires = [ "postgresql.service" ];
      after = [ "postgresql.service" ];
    };
    services.postgresql = {
      enable = true;
      ensureDatabases = [ "nextcloud" ];
      ensureUsers = [
        {
          name = "nextcloud";
          ensureDBOwnership = true;
        }
      ];
    };

    services.nextcloud = {
      enable = true;
      package = pkgs.nextcloud30;
      hostName = "nextcloud";
      configureRedis = true;
      maxUploadSize = "20G";

      # https = true;
      # autoUpdateApps.enable = true;
      # database.createLocally = true;

      # extraApps = with config.services.nextcloud.package.packages.apps; {
      #   inherit calendar contacts mail;
      #   inherit notes onlyoffice tasks;
      # };

      settings = {
        overwriteprotocol = "https";
        overwritehost = "cloud.${config.baseDomain}";
        overwrite.cli.url = "https://cloud.${config.baseDomain}";
        mail_smtpmode = "sendmail";
        mail_sendmailmode = "pipe";
        enabledPreviewProviders = [
          "OC\\Preview\\GIF"
          "OC\\Preview\\JPEG"
          "OC\\Preview\\MarkDown"
          "OC\\Preview\\OpenDocument"
          "OC\\Preview\\PNG"
          "OC\\Preview\\TXT"
        ];
      };

      config = {
        dbtype = "pgsql";
        dbuser = "nextcloud";
        dbhost = "/run/postgresql";
        dbname = "nextcloud";
        adminuser = "andreas";
        # adminpassFile = cfg.adminpassFile; # TODO use sops
      };
    };
  };
}
