{ config, lib, ... }:
let
  cfg = config.homelab.lidarr;
in
{
  options.homelab.lidarr = {
    enable = lib.mkEnableOption "Enable Lidarr";
    category = lib.mkOption {
      type = lib.types.str;
      default = "Arr";
    };
    homepage = lib.mkOption {
      type = lib.types.attrs;
      default = {
        name = "Lidarr";
        icon = "lidarr.svg";
        description = "Shh";
        href = "http://192.168.1.223:8686";
        siteMonitor = "http://localhost:8686";
      };
    };
  };
  config = lib.mkIf cfg.enable {
    services.lidarr = {
      enable = true;
      openFirewall = true;
    };
  };
}
