{ config, lib, ... }:
let
  cfg = config.homelab.homepage;
in
{
  options.homelab.homepage.enable = lib.mkEnableOption "Enable Homepage";
  config = lib.mkIf cfg.enable {
    services.glances.enable = true;
    systemd.services.homepage-dashboard.serviceConfig.Environment = [
      "HOMEPAGE_ALLOWED_HOSTS=*"
    ];
    services.homepage-dashboard = {
      enable = true;
      openFirewall = true;
      settings = {
        layout = [
          {
            Glances = {
              header = false;
              style = "row";
              columns = 4;
            };
          }
          { Media.style = "column"; }
          { Arr.style = "column"; }
          { Services.style = "column"; }
        ];
        statusStyle = "dot";
      };

      services = [
        {
          Services = [
            {
              Vaultwarden = {
                name = "Vaultwarden";
              };
            }
            {
              Uptime-Kuma = {
                name = "Uptime Kuma";
                description = "Service monitoring tool";
                icon = " uptime-kuma.svg";
                href = "http://192.168.1.223:3001";
                siteMonitor = "http://localhost:3001";
              };
            }
          ];
        }
        {
          Arr = [
            {
              Radarr = {
                name = "Radarr";
              };
            }
          ];
        }
        {
          Media = [
            {
              jellyfin = {
                name = "Jellyfin";
                icon = "jellyfin.svg";
                description = "The Free Software Media System";
                href = "http://192.168.1.223:8096";
                siteMonitor = "http://localhost:8096";
              };
            }
            {
              immich = {
                name = "Immich";
                icon = "immich.svg";
                description = "Self-hosted photo and video management solution";
                href = "http://192.168.1.223:2283";
                siteMonitor = "http://localhost:2283";
              };
            }
          ];
        }
        {
          Glances =
            let
              port = toString config.services.glances.port;
            in
            [
              {
                Info = {
                  widget = {
                    type = "glances";
                    url = "http://localhost:${port}";
                    metric = "info";
                    chart = false;
                    version = 4;
                  };
                };
              }
              {
                "CPU Temp" = {
                  widget = {
                    type = "glances";
                    url = "http://localhost:${port}";
                    metric = "sensor:Package id 0";
                    chart = false;
                    version = 4;
                  };
                };
              }
              {
                Processes = {
                  widget = {
                    type = "glances";
                    url = "http://localhost:${port}";
                    metric = "process";
                    chart = false;
                    version = 4;
                  };
                };
              }
              {
                Network = {
                  widget = {
                    type = "glances";
                    url = "http://localhost:${port}";
                    metric = "network:enp2s0f1";
                    chart = false;
                    version = 4;
                  };
                };
              }
            ];
        }
      ];
    };
  };
}
