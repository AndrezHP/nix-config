{ config, lib, ... }:
let
  cfg = config.homelab.immich;
in
{
  options.homelab.immich.enable = lib.mkEnableOption "Enable Immich";
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
