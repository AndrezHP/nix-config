{ config, lib, ... }:
let
  cfg = config.homelab.samba;
in
{
  options.homelab.samba.enable = lib.mkEnableOption "Enable Samba ";

  config = lib.mkIf cfg.enable {
    services.samba = {
      enable = true;
      openFirewall = true;
      settings = {
        global = {
          "workgroup" = "WORKGROUP";
          "server string" = "smbnix";
          "netbios name" = "smbnix";
          "security" = "user";
          "client min protocol" = "SMB2";
          "client max protocol" = "SMB3";
          "hosts allow" = "192.168.1. 127.0.0.1 localhost";
          "hosts deny" = "0.0.0.0/0";
          "guest account" = "nobody";
          "map to guest" = "bad user";
        };
        # sudo mount -t cifs //192.168.1.223/public /mnt/samba_share -o username=<username>, vers=3.0
        "public" = {
          "path" = "/mnt/Shares/Public";
          "writable" = "yes";
          "guest ok" = "no";
          "valid users" = "@wheel";
          "create mask" = "0775";
          "directory mask" = "0775";
        };
      };
    };

    services.samba-wsdd = {
      enable = true;
      openFirewall = true;
    };

    networking.firewall.enable = true;
    networking.firewall.allowPing = true;
  };
}
