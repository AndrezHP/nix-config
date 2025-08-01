{ config, lib, ... }:
let
  cfg = config.homelab.deluge;
  url = "https://deluge.${config.baseDomain}";
  port = 8112;
in
{
  options.homelab.deluge = {
    enable = lib.mkEnableOption "Enable Deluge";
    category = lib.mkOption {
      type = lib.types.str;
      default = "Arr";
    };
    homepage = lib.mkOption {
      type = lib.types.attrs;
      default = {
        name = "Deluge";
        icon = "deluge.svg";
        description = "Shh";
        href = url;
        siteMonitor = url;
      };
    };
  };
  config = lib.mkIf cfg.enable {
    services.caddy.virtualHosts."${url}" = {
      useACMEHost = config.baseDomain;
      extraConfig = ''
        reverse_proxy http://127.0.0.1:${toString port}
      '';
    };

    # Create directories for deluge volumes
    systemd.tmpfiles.rules = [
      "d /var/deluge/config 0755 andreas users -"
      "d /var/deluge/downloads 0755 andreas users -"
    ];

    virtualisation.podman.enable = true;
    virtualisation.oci-containers.containers = {
      ###### Deluge ######
      deluge = {
        image = "linuxserver/deluge:latest";
        autoStart = true;
        dependsOn = [ "gluetun" ];
        ports = [
          "8112:8112"
          "6881:6881"
        ];
        extraOptions = [
          "--pull=newer"
          "--network=container:gluetun"
        ];
        volumes = [
          "/var/deluge/config:/config"
          "/var/deluge/downloads:/var/deluge/downloads"
        ];
        environmentFiles = [
          config.sops.secrets.gluetunEnv.path
        ];
        environment = {
          PUID = "1000";
          PGID = "1000";
          TZ = "Etc/UTC";
        };
      };

      ###### Gluetun ######
      gluetun = {
        image = "qmcgaw/gluetun";
        ports = [
          "8388:8388"
          # Deluge
          "58846:58846"
          "8112:8112"
        ];
        devices = [ "/dev/net/tun:/dev/net/tun" ];
        autoStart = true;
        extraOptions = [
          "--pull=newer"
          "--cap-add=NET_ADMIN"
        ];
        volumes = [ "/var:/gluetun" ];
        environmentFiles = [
          config.sops.secrets.gluetunEnv.path
        ];
        environment = {
          DEV_MODE = "false";
          VPN_SERVICE_PROVIDER = "mullvad";
          VPN_TYPE = "wireguard";
          SERVER_CITIES = "Amsterdam";
        };
      };
    };
  };
}
