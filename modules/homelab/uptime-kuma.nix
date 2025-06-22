{ config, lib, ... }:
let
  cfg = config.homelab.uptime-kuma;
in
{
  options.homelab.uptime-kuma = {
    enable = lib.mkEnableOption "Enable Uptime Kuma";
    category = lib.mkOption {
      type = lib.types.str;
      default = "Services";
    };
    homepage = lib.mkOption {
      type = lib.types.attrs;
      default = {
        name = "uptime-kuma";
        description = "Service monitoring tool";
        icon = " uptime-kuma.svg";
        href = "http://192.168.1.223:3001";
        siteMonitor = "http://localhost:3001";
      };
    };
  };
  config = lib.mkIf cfg.enable {
    services.uptime-kuma.enable = true;
    networking.firewall.allowedTCPPorts = [ 3001 ];
    systemd.services.uptime-kuma.serviceConfig.Environment = [
      "HOST=0.0.0.0"
    ];
  };
}
