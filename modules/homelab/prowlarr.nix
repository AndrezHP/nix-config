{ config, lib, ... }:
let
  cfg = config.homelab.prowlarr;
in
{
  options.homelab.prowlarr = {
    enable = lib.mkEnableOption "Enable Prowlarr";
    category = lib.mkOption {
      type = lib.types.str;
      default = "Arr";
    };
    homepage = lib.mkOption {
      type = lib.types.attrs;
      default = {
        name = "Prowlarr";
        icon = "prowlarr.svg";
        description = "Shh";
        href = "http://192.168.1.223:9696";
        siteMonitor = "http://localhost:9696";
      };
    };
  };
  config = lib.mkIf cfg.enable {
    services.prowlarr = {
      enable = true;
      openFirewall = true;
    };
  };
}
