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
      default = "/mnt/share";
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
    systemd.tmpfiles.rules = [ "d ${cfg.mediaDir}/immich 0775 immich ${hl.group} -" ];
    services.caddy.virtualHosts."${url}" = {
      useACMEHost = config.baseDomain;
      extraConfig = ''
        reverse_proxy http://${config.services.immich.host}:${toString port}
      '';
    };
  };
}
