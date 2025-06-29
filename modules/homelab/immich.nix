{ config, lib, ... }:
let
  cfg = config.homelab.immich;
  url = "http://immich.${config.baseDomain}";
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
      host = "0.0.0.0";
      accelerationDevices = null;
    };
    users.users.immich.extraGroups = [
      "video"
      "render"
    ];
    services.caddy.virtualHosts."${url}".extraConfig = ''
      reverse_proxy http://127.0.0.1:${port}
    '';
  };
}
