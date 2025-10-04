{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.homelab.jellyfin;
  hl = config.homelab;
  url = "https://jellyfin.${config.baseDomain}";
  port = 8096;
in
{
  options.homelab.jellyfin = {
    enable = lib.mkEnableOption "Enable Jellyfin";
    category = lib.mkOption {
      type = lib.types.str;
      default = "Media";
    };
    mediaDir = lib.mkOption {
      type = lib.types.str;
      default = "/mnt/share";
    };
    homepage = lib.mkOption {
      type = lib.types.attrs;
      default = {
        name = "Jellyfin";
        icon = "jellyfin.svg";
        description = "The Free Software Media System";
        href = url;
        siteMonitor = url;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.tmpfiles.rules = [
      "d ${cfg.mediaDir}/movies 0755 ${hl.user} ${hl.group} -"
      "d ${cfg.mediaDir}/shows 0755 ${hl.user} ${hl.group} -"
    ];
    nixpkgs.config.packageOverrides = pkgs: {
      vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
    };
    hardware.graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver
        intel-vaapi-driver # previously vaapiIntel
        vaapiVdpau
        libvdpau-va-gl
        intel-compute-runtime # OpenCL filter support (hardware tonemapping and subtitle burn-in)
        vpl-gpu-rt # QSV on 11th gen or newer
        # intel-media-sdk # QSV up to 11th gen # Deprecated
      ];
    };
    services.jellyfin = {
      enable = true;
      user = config.homelab.user;
      group = config.homelab.user;
    };
    services.caddy.virtualHosts."${url}" = {
      useACMEHost = config.baseDomain;
      extraConfig = ''
        reverse_proxy http://127.0.0.1:${toString port}
      '';
    };
  };
}
