{ config, lib, ... }:
let
  cfg = config.homelab.bazarr;
  port = toString config.services.bazarr.listenPort;
in
{
  options.homelab.bazarr = {
    enable = lib.mkEnableOption "Enable Bazarr";
    category = lib.mkOption {
      type = lib.types.str;
      default = "Arr";
    };
    homepage = lib.mkOption {
      type = lib.types.attrs;
      default = {
        name = "Bazarr";
        icon = "bazarr.svg";
        description = "Shh";
        href = "http://192.168.1.223:${port}";
        siteMonitor = "http://localhost:${port}";
      };
    };
  };
  config = lib.mkIf cfg.enable {
    services.bazarr = {
      enable = true;
      openFirewall = true;
    };
  };
}
