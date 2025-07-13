{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.homelab.nextcloud;
  url = "https://cloud.${config.baseDomain}";
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
        href = url;
        siteMonitor = url;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.caddy.virtualHosts."${url}" = {
      useACMEHost = config.baseDomain;
      extraConfig = ''
        reverse_proxy http://127.0.0.1:${toString port}
      '';
    };
    services.nginx = {
      enable = true;
      virtualHosts."${config.services.nextcloud.hostName}" = {
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
      package = pkgs.nextcloud31;
      hostName = "nextcloud";
      configureRedis = true;
      maxUploadSize = "20G";
      database.createLocally = true;

      autoUpdateApps.enable = true;
      extraApps = with config.services.nextcloud.package.packages.apps; {
        inherit calendar contacts mail;
        inherit notes onlyoffice tasks;
      };

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
        adminuser = "admin";
        adminpassFile = config.sops.secrets.nextcloudAdminPassword.path;
      };
    };
  };
}
