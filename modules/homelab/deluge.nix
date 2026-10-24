{ config, lib, ... }:
let
  cfg = config.homelab.deluge;
  hl = config.homelab;
  downloadDir = "/mnt/media/downloads";
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

    # Create directories for deluge and gluetun volumes
    systemd.tmpfiles.rules = [
      "d /var/deluge/config 0775 ${hl.user} ${hl.group} -"
      # On the media dataset, so the files can hardlinked into the library
      "d ${downloadDir} 0775 ${hl.user} ${hl.group} -"
      "d /var/gluetun 0755 root root -"
    ];

    # Set Deluge's listen port to the port forwarded by the VPN, whenever it changes
    systemd.paths.deluge-port-forward = {
      wantedBy = [ "multi-user.target" ];
      pathConfig.PathChanged = "/var/gluetun/forwarded_port";
    };
    systemd.services.deluge-port-forward = {
      description = "Set Deluge listen port to the VPN forwarded port";
      after = [ "podman-deluge.service" ];
      wantedBy = [ "podman-deluge.service" ];
      path = [ config.virtualisation.podman.package ];
      serviceConfig.Type = "oneshot";
      script = ''
        file=/var/gluetun/forwarded_port
        [ -s "$file" ] || exit 0
        port=$(head -n1 "$file")
        # Retry while the Deluge daemon is starting up
        for _ in $(seq 30); do
          if podman exec -u abc deluge deluge-console -c /config \
            "config -s random_port False; config -s listen_ports ($port, $port)"; then
            echo "Deluge listen port set to $port"
            exit 0
          fi
          sleep 2
        done
        echo "Failed to set Deluge listen port" >&2
        exit 1
      '';
    };

    virtualisation.podman.enable = true;
    virtualisation.oci-containers.containers = {
      ###### Deluge ######
      deluge = {
        image = "linuxserver/deluge:latest";
        autoStart = true;
        dependsOn = [ "gluetun" ];
        extraOptions = [
          "--pull=newer"
          "--network=container:gluetun"
        ];
        volumes = [
          "/var/deluge/config:/config"
          "${downloadDir}:${downloadDir}"
        ];
        environment = {
          # Run as the homelab user, so the Arr apps can manage the downloads
          PUID = toString config.users.users.${hl.user}.uid;
          PGID = toString config.users.groups.${hl.group}.gid;
          # Give the group write access, matching the 0775 used elsewhere (e.g. write permissions over SMB)
          UMASK = "002";
          TZ = "Etc/UTC";
        };
      };

      ###### Gluetun ######
      gluetun = {
        image = "qmcgaw/gluetun";
        ports = [
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
        volumes = [ "/var/gluetun:/gluetun" ];
        environmentFiles = [
          config.sops.secrets.gluetunEnv.path
        ];
        environment = {
          DEV_MODE = "false";
          VPN_SERVICE_PROVIDER = "protonvpn";
          VPN_TYPE = "wireguard";
          SERVER_CITIES = "Amsterdam";
          PORT_FORWARD_ONLY = "on";
          VPN_PORT_FORWARDING = "on";
          VPN_PORT_FORWARDING_STATUS_FILE = "/gluetun/forwarded_port";
        };
      };
    };
  };
}
