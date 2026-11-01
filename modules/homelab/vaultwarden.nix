{ config, lib, ... }:
let
  cfg = config.homelab.vaultwarden;
  hl = config.homelab;
  url = "https://vault.${config.baseDomain}";
  backupDir = "/mnt/media/backup/vaultwarden";
  port = 8222;
in
{
  options.homelab.vaultwarden = {
    enable = lib.mkEnableOption "Enable Vaultwarden";
    category = lib.mkOption {
      type = lib.types.str;
      default = "Services";
    };
    homepage = lib.mkOption {
      type = lib.types.attrs;
      default = {
        name = "Vaultwarden";
        icon = "vaultwarden.svg";
        description = "Password manager";
        href = url;
        siteMonitor = url;
      };
    };
  };
  config = lib.mkIf cfg.enable {
    services.vaultwarden = {
      enable = true;
      inherit backupDir;
      config = {
        DOMAIN = url;
        SIGNUPS_ALLOWED = false;
        ROCKET_ADDRESS = "127.0.0.1";
        ROCKET_PORT = port;
        EXTENDED_LOGGING = true;
        LOG_LEVEL = "warn";
        IP_HEADER = "CF-Connecting-IP";
      };
    };
    # /mnt/media/backup is owned by the homelab user; tmpfiles refuses a child owned by
    # another user (unsafe path transition), so own it as homelab and let the backup job in via the group
    systemd.tmpfiles.settings."10-vaultwarden".${backupDir}.d = {
      user = lib.mkForce hl.user;
      group = lib.mkForce hl.group;
    };
    systemd.services.backup-vaultwarden = {
      unitConfig.RequiresMountsFor = [ backupDir ];
      serviceConfig.SupplementaryGroups = [ hl.group ];
    };
    services.caddy.virtualHosts."${url}" = {
      useACMEHost = config.baseDomain;
      extraConfig = ''
        reverse_proxy http://127.0.0.1:${toString port}
      '';
    };
  };
}
