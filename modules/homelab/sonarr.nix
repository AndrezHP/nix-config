{ config, lib, ... }:
let
  cfg = config.homelab.sonarr;
in
{
  options.homelab.sonarr = {
    enable = lib.mkEnableOption "Enable Sonarr";
    category = lib.mkOption {
      type = lib.types.str;
      default = "Arr";
    };
    homepage = lib.mkOption {
      type = lib.types.attrs;
      default = {
        name = "Sonarr";
        icon = "sonarr.svg";
        description = "Shh";
        href = "http://192.168.1.223:8989";
        siteMonitor = "http://localhost:8989";
      };
    };
  };
  config = lib.mkIf cfg.enable {
    services.sonarr = {
      enable = true;
      openFirewall = true;
    };
  };
}
