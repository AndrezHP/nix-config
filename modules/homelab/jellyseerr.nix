{ config, lib, ... }:
let
  cfg = config.homelab.jellyseerr;
  url = "https://seerr.${config.baseDomain}";
  port = 5055;
in
{
  options.homelab.jellyseerr = {
    enable = lib.mkEnableOption "Enable Jellyseerr";
    category = lib.mkOption {
      type = lib.types.str;
      default = "Arr";
    };
    homepage = lib.mkOption {
      type = lib.types.attrs;
      default = {
        name = "Jellyseerr";
        icon = "jellyseerr.svg";
        description = "Shh";
        href = url;
        siteMonitor = url;
      };
    };
  };
  config = lib.mkIf cfg.enable {
    services.jellyseerr = {
      enable = true;
      user = config.homelab.user;
      group = config.homelab.user;
      inherit port;
    };
    services.caddy.virtualHosts."${url}" = {
      useACMEHost = config.baseDomain;
      extraConfig = ''
        reverse_proxy http://127.0.0.1:${toString port}
      '';
    };
  };
}
