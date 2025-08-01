{ config, lib, ... }:
let
  cfg = config.homelab.homepage;
  port = 8082;
  categories = [
    "Media"
    "Arr"
    "Services"
  ];
  filterOnCategory =
    services: x:
    (lib.attrsets.filterAttrs (
      name: value: value ? homepage && value.category == x && value.enable
    ) services);
in
{
  options.homelab = {
    homepage.enable = lib.mkEnableOption "Enable Homepage";
    networkInterface = lib.mkOption {
      type = lib.types.str;
      description = "Network interfaces";
      default = "";
    };
  };

  config = lib.mkIf cfg.enable {
    services.caddy.virtualHosts."${config.baseDomain}" = {
      useACMEHost = config.baseDomain;
      extraConfig = ''
        reverse_proxy http://127.0.0.1:${toString port}
      '';
    };
    services.glances.enable = true;
    systemd.services.homepage-dashboard.serviceConfig.Environment = [
      "HOMEPAGE_ALLOWED_HOSTS=*"
    ];
    services.homepage-dashboard = {
      enable = true;
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
          { Services.style = "column"; }
          { Arr.style = "column"; }
          {
            Disabled = {
              style = "row";
              columns = 6;
            };
          }
        ];
        statusStyle = "dot";
      };
      services =
        lib.lists.forEach categories (cat: {
          "${cat}" =
            lib.lists.forEach
              (lib.attrsets.mapAttrsToList (name: value: name) (filterOnCategory config.homelab "${cat}"))
              (x: {
                "${config.homelab.${x}.homepage.name}" = config.homelab.${x}.homepage;
              });
        })
        ++ [
          {
            Glances =
              let
                mapGlances = name: metric: {
                  "${name}" = {
                    widget = {
                      type = "glances";
                      url = "http://localhost:${toString config.services.glances.port}";
                      metric = metric;
                      chart = false;
                      version = 4;
                    };
                  };
                };
              in
              [
                (mapGlances "Info" "info")
                (mapGlances "CPU Temp" "sensor:Package id 0")
                (mapGlances "Processes" "process")
                lib.mkIf
                (config.homelab.networkInterface != "")
                (mapGlances "Network" config.homelab.networkInterface)
              ];
          }
          {
            Disabled =
              let
                disabledServices = (
                  lib.attrsets.mapAttrsToList (name: value: name) (
                    (lib.attrsets.filterAttrs (name: value: value ? homepage && value.enable == false) config.homelab)
                  )
                );
              in
              (lib.lists.forEach disabledServices (x: {
                "${config.homelab.${x}.homepage.name}" = config.homelab.${x}.homepage;
              }));
          }
        ];
    };
  };
}
