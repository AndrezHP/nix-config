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
  options.homelab.samba = {
    enable = lib.mkEnableOption "Enable Samba";
    shares = lib.mkOption "Specify samba shares" {
      type = lib.types.attrs;
      default = {
        Share = {
          path = "/mnt/share";
        };
      };
      example = lib.literalExpression ''
        Share = {
          path = "/mnt/share";
        }
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.tmpfiles.rules = map (x: "d ${x.path} 0775 ${hl.user} ${hl.group} - -") (
      lib.attrValues cfg.shares
    );
    system.activationScripts.samba_user_create = ''
      smb_password=$(cat "${config.sops.secrets.sambaPassword.path}")
      echo -e "$smb_password\n$smb_password\n" | ${lib.getExe' pkgs.samba "smbpasswd"} -a -s ${hl.user}
    '';

    services.samba =
      let
        common = {
          "path" = "/mnt/share";
          "browseable" = "yes";
          "writeable" = "yes";
          "read only" = "no";
          "guest ok" = "no";
          "create mask" = "0775";
          "directory mask" = "0775";
          "valid users" = "${hl.user}, @${hl.group}, andreas";
        };
      in
      {
        enable = true;
        openFirewall = true;
        settings = {
          global = {
            "workgroup" = "WORKGROUP";
            "server string" = "smbnix";
            "netbios name" = "smbnix";
            "security" = "user";
            "hosts allow" = "192.168.1.0/24 192.168.8.0/24 127.0.0.1 localhost";
            "hosts deny" = "0.0.0.0/0";
            "guest account" = "nobody";
            "map to guest" = "bad user";
          };
          # sudo mount -t cifs //<ip>/share /mnt/samba_share -o username=<username>,password=<password>
          # Remember to set: smbpasswd -a <user>
        }
        // builtins.mapAttrs (name: value: value // common) cfg.shares;
      };

    services.samba-wsdd = {
      enable = true;
      openFirewall = true;
    };

    networking.firewall.enable = true;
    networking.firewall.allowPing = true;
  };
}
