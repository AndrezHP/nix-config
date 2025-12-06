{
  config,
  lib,
  ...
}:
let
  cfg = config.homelab.gitea;
  hl = config.homelab;
  url = "https://gitea.${config.baseDomain}";
  port = 3077;
in
{
  options.homelab.gitea = {
    enable = lib.mkEnableOption "Enable Gitea";
    stateDir = lib.mkOption {
      type = lib.types.str;
      default = "/mnt/backup/Other/gitea";
    };
    category = lib.mkOption {
      type = lib.types.str;
      default = "Services";
    };
    homepage = lib.mkOption {
      type = lib.types.attrs;
      default = {
        name = "Gitea";
        icon = "gitea.svg";
        description = "Git forge";
        href = url;
        siteMonitor = url;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.tmpfiles.rules = [ "d ${cfg.stateDir} 0775 ${hl.user} ${hl.group} -" ];
    services.gitea = {
      enable = true;
      user = hl.user;
      group = hl.group;
      stateDir = cfg.stateDir;
      lfs.enable = true; # Large file support
      settings.server = {
        HTTP_PORT = port;
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
