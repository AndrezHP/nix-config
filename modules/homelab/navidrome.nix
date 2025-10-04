{
  config,
  lib,
  ...
}:
let
  cfg = config.homelab.navidrome;
  hl = config.homelab;
  url = "https://navidrome.${config.baseDomain}";
  port = 4533;
in
{
  options.homelab.navidrome = {
    enable = lib.mkEnableOption "Enable Navidrome";
    mediaDir = lib.mkOption {
      type = lib.types.str;
      default = "/mnt/share";
    };
    category = lib.mkOption {
      type = lib.types.str;
      default = "Media";
    };
    homepage = lib.mkOption {
      type = lib.types.attrs;
      default = {
        name = "Navidrome";
        icon = "navidrome.svg";
        description = "Your Personal Streaming Service";
        href = url;
        siteMonitor = url;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.tmpfiles.rules = [ "d ${cfg.mediaDir}/music 0775 ${hl.user} ${hl.group} -" ];
    services.navidrome = {
      enable = true;
      user = hl.user;
      group = hl.group;
      settings = {
        MusicFolder = "${cfg.mediaDir}/music";
      };
    };
    services.caddy.virtualHosts."${url}" = {
      useACMEHost = config.baseDomain;
      extraConfig = ''
        reverse_proxy http://127.0.0.1:${toString port}
      '';
    };
  };
}
