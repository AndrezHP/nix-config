{ config, lib, ... }:
let
  cfg = config.homelab.lidarr;
  url = "https://lid.${config.baseDomain}";
  port = 8686;
in
{
  options.homelab.lidarr = {
    enable = lib.mkEnableOption "Enable Lidarr";
    category = lib.mkOption {
      type = lib.types.str;
      default = "Arr";
    };
    homepage = lib.mkOption {
      type = lib.types.attrs;
      default = {
        name = "Lidarr";
        icon = "lidarr.svg";
        description = "Shh";
        href = url;
        siteMonitor = url;
      };
    };
  };
  config = lib.mkIf cfg.enable {
    services.lidarr.enable = true;
    services.caddy.virtualHosts."${url}" = {
      useACMEHost = config.baseDomain;
      extraConfig = ''
        reverse_proxy http://127.0.0.1:${toString port}
      '';
    };
  };
}
