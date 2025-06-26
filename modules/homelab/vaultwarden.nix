{ config, lib, ... }:
let
  cfg = config.homelab.vaultwarden;
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
        href = "http://192.168.1.223:8222";
        siteMonitor = "http://localhost:8222";
      };
    };
  };
  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ 8222 ];
    services.vaultwarden = {
      enable = true;
      backupDir = "/var/backup/vaultwarden";
      config = {
        DOMAIN = "https://192.168.1.223:8222";
        SIGNUPS_ALLOWED = true;
        ROCKET_ADDRESS = "0.0.0.0";
        ROCKEt_PORT = 8222;
        EXTENDED_LOGGING = true;
        LOG_LEVEL = "warn";
        IP_HEADER = "CF-Connecting-IP";
      };
    };
  };
}
