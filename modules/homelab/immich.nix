{ config, lib, ... }:
let
  cfg = config.homelab.immich;
  url = "https://immich.${config.baseDomain}";
  port = 2283;
  hl = config.homelab;
in
{
  options.homelab.immich = {
    enable = lib.mkEnableOption "Enable Immich";
    category = lib.mkOption {
      type = lib.types.str;
      default = "Media";
    };
    mediaDir = lib.mkOption {
      type = lib.types.str;
      default = "/mnt/media/immich";
    };
    homepage = lib.mkOption {
      type = lib.types.attrs;
      default = {
        name = "Immich";
        icon = "immich.svg";
        description = "Self-hosted photo and video management";
        href = url;
        siteMonitor = url;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.tmpfiles.rules = [ "d ${cfg.mediaDir} 0700 ${hl.user} ${hl.group} -" ];
    systemd.services.immich-server.unitConfig.RequiresMountsFor = [ cfg.mediaDir ];
    services.immich = {
      enable = true;
      user = hl.user;
      group = hl.group;
      # Postgres peer auth: db user (and db name, for ensureDBOwnership) must match the unix user
      database.user = hl.user;
      database.name = hl.user;
      host = "127.0.0.1";
      inherit port;
      mediaLocation = cfg.mediaDir;
    };
    services.caddy.virtualHosts."${url}" = {
      useACMEHost = config.baseDomain;
      extraConfig = ''
        reverse_proxy http://127.0.0.1:${toString port}
      '';
    };
  };
}
