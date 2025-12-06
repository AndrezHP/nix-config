{
  config,
  lib,
  ...
}:
let
  cfg = config.homelab.forgejo;
  hl = config.homelab;
  url = "https://forgejo.${config.baseDomain}";
  port = 3078;
in
{
  options.homelab.forgejo = {
    enable = lib.mkEnableOption "Enable Forgejo";
    stateDir = lib.mkOption {
      type = lib.types.str;
      default = "/mnt/backup/Other/forgejo";
    };
    category = lib.mkOption {
      type = lib.types.str;
      default = "Services";
    };
    homepage = lib.mkOption {
      type = lib.types.attrs;
      default = {
        name = "Forgejo";
        icon = "forgejo.svg";
        description = "Git forge";
        href = url;
        siteMonitor = url;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.tmpfiles.rules = [ "d ${cfg.stateDir} 0775 ${hl.user} ${hl.group} -" ];
    services.forgejo = {
      enable = true;
      user = hl.user;
      group = hl.group;
      stateDir = cfg.stateDir;
      lfs.enable = true; # Large file support
      settings = {
        server = {
          HTTP_PORT = port;
          ROOT_URL = url;
        };
        actions = {
          ENABLED = true;
          DEFAULT_ACTIONS_URL = "github";
        };
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
