{ config, lib, ... }:
let
  cfg = config.homelab.microbin;
  url = "http://bin.${config.baseDomain}";
  port = 8080;
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
        href = url;
        siteMonitor = url;
      };
    };
  };
  config = lib.mkIf cfg.enable {
    services.microbin = {
      enable = true;
      settings = {
        MICROBIN_BIND = "0.0.0.0";
        MICROBIN_PORT = port;
        MICROBIN_DISABLE_TELEMETRY = true;
      };
    };
    services.caddy.virtualHosts."${url}".extraConfig = ''
      reverse_proxy http://127.0.0.1:${port}
    '';
  };
}
