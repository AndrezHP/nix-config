{ config, lib, ... }:
let
  cfg = config.homelab.bazarr;
  url = "http://baz.${config.baseDomain}";
  port = toString config.services.bazarr.listenPort;
in
{
  options.homelab.bazarr = {
    enable = lib.mkEnableOption "Enable Bazarr";
    category = lib.mkOption {
      type = lib.types.str;
      default = "Arr";
    };
    homepage = lib.mkOption {
      type = lib.types.attrs;
      default = {
        name = "Bazarr";
        icon = "bazarr.svg";
        description = "Shh";
        href = url;
        siteMonitor = "http://127.0.0.1:${toString port}";
      };
    };
  };
  config = lib.mkIf cfg.enable {
    services.bazarr.enable = true;
    services.caddy.virtualHosts."${url}".extraConfig = ''
      reverse_proxy http://127.0.0.1:${toString port}
    '';
  };
}
