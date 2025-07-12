{ config, lib, ... }:
let
  cfg = config.homelab.adguard-home;
  url = "https://adguard.${config.baseDomain}";
  port = 3031;
in
{
  options.homelab.adguard-home = {
    enable = lib.mkEnableOption "Enable AdGuard Home";
    category = lib.mkOption {
      type = lib.types.str;
      default = "Services";
    };
    homepage = lib.mkOption {
      type = lib.types.attrs;
      default = {
        name = "AdGuard Home";
        icon = "adguard-home.svg";
        description = "DNS server";
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
    networking.firewall.allowedUDPPorts = [ 53 ];
    services.adguardhome = {
      enable = true;
      inherit port;
      settings = {
        http.address = "127.0.0.1:${toString port}";
        dns.upstream_dns = [
          "https://base.dns.mullvad.net/dns-query"
          "8.8.8.8"
        ];
        filtering.protection_enabled = true;
        filtering.filtering_enabled = true;
        filters =
          map
            (url: {
              enabled = true;
              url = url;
            })
            [
              "https://adguardteam.github.io/HostlistsRegistry/assets/filter_11.txt"
              "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/nsfw.txt"
            ];
      };
    };
  };
}
