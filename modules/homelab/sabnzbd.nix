{ config, lib, ... }:
let
  cfg = config.homelab.sabnzbd;
  url = "https://sabnzbd.${config.baseDomain}";
  port = 8080;
in
{
  options.homelab.sabnzbd = {
    enable = lib.mkEnableOption "Enable SABnzbd";
    category = lib.mkOption {
      type = lib.types.str;
      default = "Arr";
    };
    homepage = lib.mkOption {
      type = lib.types.attrs;
      default = {
        name = "SABnzbd";
        icon = "sabnzbd.svg";
        description = "Shh";
        href = url;
        siteMonitor = url;
      };
    };
  };
  config = lib.mkIf cfg.enable {
    services.sabnzbd.enable = true;
    services.caddy.virtualHosts."${url}" = {
      useACMEHost = config.baseDomain;
      extraConfig = ''
        reverse_proxy http://127.0.0.1:${toString port}
      '';
    };
  };
}
