{ config, lib, ... }:
let
  cfg = config.homelab.prowlarr;
  url = "http://prowl.${config.baseDomain}";
  port = 9696;
in
{
  options.homelab.prowlarr = {
    enable = lib.mkEnableOption "Enable Prowlarr";
    category = lib.mkOption {
      type = lib.types.str;
      default = "Arr";
    };
    homepage = lib.mkOption {
      type = lib.types.attrs;
      default = {
        name = "Prowlarr";
        icon = "prowlarr.svg";
        description = "Shh";
        href = url;
        siteMonitor = "http://127.0.0.1:${toString port}";
      };
    };
  };
  config = lib.mkIf cfg.enable {
    services.prowlarr.enable = true;
    services.caddy.virtualHosts."${url}".extraConfig = ''
      reverse_proxy http://127.0.0.1:${toString port}
    '';
  };
}
