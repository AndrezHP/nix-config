{ config, lib, ... }:
let
  cfg = config.homelab.bazarr;
  url = "https://baz.${config.baseDomain}";
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
        siteMonitor = url;
      };
    };
  };
  config = lib.mkIf cfg.enable {
    services.bazarr = {
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
