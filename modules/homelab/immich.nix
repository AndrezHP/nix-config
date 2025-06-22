{ config, lib, ... }:
let
  cfg = config.homelab.immich;
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
        description = "Self-hosted photo and video management solution";
        href = "http://192.168.1.223:2283";
        siteMonitor = "http://localhost:2283";
      };
    };
  };
  config = lib.mkIf cfg.enable {
    services.immich = {
      enable = true;
      openFirewall = true;
      host = "0.0.0.0";
      accelerationDevices = null;
    };
    users.users.immich.extraGroups = [
      "video"
      "render"
    ];
  };
}
