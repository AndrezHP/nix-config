{ config, lib, ... }:
let
  cfg = config.homelab.sonarr;
  url = "http://son.${config.baseDomain}";
  port = 8989;
in
{
  options.homelab.sonarr = {
    enable = lib.mkEnableOption "Enable Sonarr";
    category = lib.mkOption {
      type = lib.types.str;
      default = "Arr";
    };
    homepage = lib.mkOption {
      type = lib.types.attrs;
      default = {
        name = "Sonarr";
        icon = "sonarr.svg";
        description = "Shh";
        href = url;
        siteMonitor = "http://127.0.0.1:${toString port}";
      };
    };
  };
  config = lib.mkIf cfg.enable {
    services.sonarr.enable = true;
    services.caddy.virtualHosts."${url}".extraConfig = ''
      reverse_proxy http://127.0.0.1:${toString port}
    '';
  };
}
