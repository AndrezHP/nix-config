{ config, lib, ... }:
let
  cfg = config.homelab.audiobookshelf;
  url = "https://audiobook.${config.baseDomain}";
  port = 8010;
in
{
  options.homelab.audiobookshelf = {
    enable = lib.mkEnableOption "Enable Audiobookshelf";
    category = lib.mkOption {
      type = lib.types.str;
      default = "Media";
    };
    homepage = lib.mkOption {
      type = lib.types.attrs;
      default = {
        name = "Audiobookshelf";
        icon = "audiobookshelf.svg";
        description = "Self-hosted audio books";
        href = url;
        siteMonitor = url;
      };
    };
  };
  config = lib.mkIf cfg.enable {
    services.audiobookshelf = {
      enable = true;
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
