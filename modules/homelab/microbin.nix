{ config, lib, ... }:
let
  cfg = config.homelab.microbin;
in
{
  options.homelab.microbin = {
    enable = lib.mkEnableOption "Enable Microbin";
    category = lib.mkOption {
      type = lib.types.str;
      default = "Services";
    };
    homepage = lib.mkOption {
      type = lib.types.attrs;
      default = {
        name = "Microbin";
        description = "Self-hosted pastebin";
        icon = "microbin.png";
        href = "http://192.168.1.223:8080";
        siteMonitor = "http://localhost:8080";
      };
    };
  };
  config = lib.mkIf cfg.enable {
    services.microbin = {
      enable = true;
      settings = {
        MICROBIN_BIND = "0.0.0.0";
        MICROBIN_PORT = 8080;
        MICROBIN_DISABLE_TELEMETRY = true;
      };
    };
    networking.firewall.allowedTCPPorts = [ 8080 ];
  };
}
