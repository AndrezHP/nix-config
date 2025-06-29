{ config, lib, ... }:
let
  cfg = config.homelab.vaultwarden;
  url = "http://vault.${config.baseDomain}";
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
        siteMonitor = "http://127.0.0.1:${toString port}";
      };
    };
  };
  config = lib.mkIf cfg.enable {
    services.vaultwarden = {
      enable = true;
      backupDir = "/var/backup/vaultwarden";
      config = {
        DOMAIN = "https://192.168.1.223:${toString port}";
        SIGNUPS_ALLOWED = true;
        ROCKET_ADDRESS = "0.0.0.0";
        ROCKET_PORT = port;
        EXTENDED_LOGGING = true;
        LOG_LEVEL = "warn";
        IP_HEADER = "CF-Connecting-IP";
      };
    };
    services.caddy.virtualHosts."${url}".extraConfig = ''
      reverse_proxy http://127.0.0.1:${toString port}
    '';
  };
}
