{ config, lib, ... }:
let
  cfg = config.homelab.uptime-kuma;
in
{
  options.homelab.uptime-kuma.enable = lib.mkEnableOption "Enable Uptime Kuma";
  config = lib.mkIf cfg.enable {
    services.uptime-kuma.enable = true;
    networking.firewall.allowedTCPPorts = [ 3001 ];
    systemd.services.uptime-kuma.serviceConfig.Environment = [
      "HOST=0.0.0.0"
    ];
  };
}
