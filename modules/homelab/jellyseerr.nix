{ config, lib, ... }:
let
  cfg = config.homelab.jellyseerr;
  url = "http://seerr.${config.baseDomain}";
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
        siteMonitor = "http://127.0.0.1:${toString port}";
      };
    };
  };
  config = lib.mkIf cfg.enable {
    services.jellyseerr = {
      enable = true;
      inherit port;
    };
    services.caddy.virtualHosts."${url}".extraConfig = ''
      reverse_proxy http://127.0.0.1:${toString port}
    '';
  };
}
