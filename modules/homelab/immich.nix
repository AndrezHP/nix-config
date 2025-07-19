{ config, lib, ... }:
let
  cfg = config.homelab.immich;
  url = "https://immich.${config.baseDomain}";
  port = 2283;
in
{
  options.homelab.immich = {
    enable = lib.mkEnableOption "Enable Immich";
    category = lib.mkOption {
      type = lib.types.str;
      default = "Media";
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
    services.immich = {
      enable = true;
      accelerationDevices = null;
      user = config.homelab.user;
      group = config.homelab.user;
    };
    users.users.immich.extraGroups = [
      "video"
      "render"
    ];
    services.caddy.virtualHosts."${url}" = {
      useACMEHost = config.baseDomain;
      extraConfig = ''
        reverse_proxy http://${config.services.immich.host}:${toString port}
      '';
    };
  };
}
