{ config, lib, ... }:
let
  cfg = config.homelab.adguard-home;
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
        href = "http://192.168.1.223:3031";
        siteMonitor = "http://localhost:3031";
      };
    };
  };
  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ 3031 ];
    networking.firewall.allowedUDPPorts = [ 53 ];
    services.adguardhome = {
      enable = true;
      openFirewall = true;
      port = 3031;
      settings = {
        http.address = "127.0.0.1:3031";
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
