{ config, lib, ... }:
let
  cfg = config.homelab.uptime-kuma;
  url = "http://uptime.${config.baseDomain}";
  port = 3001;
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
        name = "Uptime Kuma";
        description = "Service monitoring tool";
        icon = "uptime-kuma.svg";
        href = url;
        siteMonitor = "http://127.0.0.1:${toString port}";
      };
    };
  };
  config = lib.mkIf cfg.enable {
    services.uptime-kuma.enable = true;
    systemd.services.uptime-kuma.serviceConfig.Environment = [
      "HOST=0.0.0.0"
    ];
    services.caddy.virtualHosts."${url}".extraConfig = ''
      reverse_proxy http://127.0.0.1:${toString port}
    '';
  };
}
