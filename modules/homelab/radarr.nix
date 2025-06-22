{ config, lib, ... }:
let
  cfg = config.homelab.radarr;
in
{
  options.homelab.radarr = {
    enable = lib.mkEnableOption "Enable Radarr";
    category = lib.mkOption {
      type = lib.types.str;
      default = "Arr";
    };
    homepage = lib.mkOption {
      type = lib.types.attrs;
      default = {
        name = "Radarr";
        icon = "radarr.svg";
        description = "Shh";
        href = "http://192.168.1.223:7878";
        siteMonitor = "http://localhost:7878";
      };
    };
  };
  config = lib.mkIf cfg.enable {
    services.radarr = {
      enable = true;
      openFirewall = true;
    };
  };
}
