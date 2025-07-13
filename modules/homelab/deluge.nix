{ config, lib, ... }:
let
  cfg = config.homelab.deluge;
  url = "https://deluge.${config.baseDomain}";
  port = 8112;
in
{
  options.homelab.deluge = {
    enable = lib.mkEnableOption "Enable Deluge";
    category = lib.mkOption {
      type = lib.types.str;
      default = "Arr";
    };
    homepage = lib.mkOption {
      type = lib.types.attrs;
      default = {
        name = "Deluge";
        icon = "deluge.svg";
        description = "Shh";
        href = url;
        siteMonitor = url;
      };
    };
  };
  config = lib.mkIf cfg.enable {
    services.deluge = {
      enable = true;
      web.enable = true;
    };
    services.caddy.virtualHosts."${url}" = {
      useACMEHost = config.baseDomain;
      extraConfig = ''
        reverse_proxy http://127.0.0.1:${toString port}
      '';
    };
  };
}
