{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.homelab.jellyfin;
  hl = config.homelab;
  url = "https://jellyfin.${config.baseDomain}";
  port = 8096;
in
{
  options.homelab.jellyfin = {
    enable = lib.mkEnableOption "Enable Jellyfin";
    category = lib.mkOption {
      type = lib.types.str;
      default = "Media";
    };
    mediaDir = lib.mkOption {
      type = lib.types.str;
      default = "/mnt/share";
    };
    homepage = lib.mkOption {
      type = lib.types.attrs;
      default = {
        name = "Jellyfin";
        icon = "jellyfin.svg";
        description = "The Free Software Media System";
        href = url;
        siteMonitor = url;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.tmpfiles.rules = [ 
      "d ${cfg.mediaDir}/movies 0775 ${hl.user} ${hl.group} -"
      "d ${cfg.mediaDir}/shows 0775 ${hl.user} ${hl.group} -" ];
    # AMD VA-API (radeonsi) ships with Mesa; Jellyfin just needs access to /dev/dri
    hardware.graphics.enable = true;
    users.users.${hl.user}.extraGroups = [
      "render"
      "video"
    ];
    services.jellyfin = {
      enable = true;
      user = config.homelab.user;
      group = config.homelab.group;
    };
    services.caddy.virtualHosts."${url}" = {
      useACMEHost = config.baseDomain;
      extraConfig = ''
        reverse_proxy http://127.0.0.1:${toString port}
      '';
    };
  };
}
