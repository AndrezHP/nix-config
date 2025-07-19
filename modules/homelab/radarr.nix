{ config, lib, ... }:
let
  cfg = config.homelab.radarr;
  url = "https://rad.${config.baseDomain}";
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
        siteMonitor = url;
      };
    };
  };
  config = lib.mkIf cfg.enable {
    services.radarr = {
      enable = true;
      user = config.homelab.user;
      group = config.homelab.user;
    };
    services.caddy.virtualHosts."${url}" = {
      useACMEHost = config.baseDomain;
      extraConfig = ''
        reverse_proxy http://127.0.0.1:${toString port}
      '';
    };
  };
}
