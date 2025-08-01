{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.homelab.samba;
  hl = config.homelab;
in
{
  options.homelab.samba.enable = lib.mkEnableOption "Enable Samba ";

  config = lib.mkIf cfg.enable {
    systemd.tmpfiles.rules = [ "d /mnt/share 0755 andreas users -" ];
    system.activationScripts.samba_user_create = ''
      smb_password=$(cat "${config.sops.secrets.sambaPassword.path}")
      echo -e "$smb_password\n$smb_password\n" | ${lib.getExe' pkgs.samba "smbpasswd"} -a -s andreas
    '';
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
          "hosts allow" = "192.168.1.0/24 127.0.0.1 localhost";
          "hosts deny" = "0.0.0.0/0";
          "guest account" = "nobody";
          "map to guest" = "bad user";
        };
        # sudo mount -t cifs //192.168.1.223/public /mnt/samba_share -o username=<username>,password=<password>
        "share" = {
          "path" = "/mnt/share";
          "writable" = "yes";
          "guest ok" = "no";
          "valid users" = "andreas";
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
