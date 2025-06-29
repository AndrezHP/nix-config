{ config, lib, ... }:
let
  cfg = config.homelab.radarr;
  url = "http://rad.${config.baseDomain}";
  port = 7878;
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
        href = url;
        siteMonitor = "http://127.0.0.1:${toString port}";
      };
    };
  };
  config = lib.mkIf cfg.enable {
    services.radarr.enable = true;
    services.caddy.virtualHosts."${url}".extraConfig = ''
      reverse_proxy http://127.0.0.1:${toString port}
    '';
  };
}
