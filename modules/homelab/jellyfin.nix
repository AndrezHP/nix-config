{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.homelab.jellyfin;
  url = "http://jellyfin.${config.baseDomain}";
  port = 8096;
in
{
  options.homelab.jellyfin = {
    enable = lib.mkEnableOption "Enable Jellyfin";
    category = lib.mkOption {
      type = lib.types.str;
      default = "Media";
    };
    homepage = lib.mkOption {
      type = lib.types.attrs;
      default = {
        name = "Jellyfin";
        icon = "jellyfin.svg";
        description = "The Free Software Media System";
        href = url;
        siteMonitor = "http://127.0.0.1:${toString port}";
      };
    };
  };

  config = lib.mkIf cfg.enable {
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
        intel-media-sdk # QSV up to 11th gen
      ];
    };
    services.jellyfin = {
      enable = true;
      user = "andreas";
    };
    services.caddy.virtualHosts."${url}" = {
      extraConfig = ''
        reverse_proxy http://127.0.0.1:${toString port}
      '';
    };
  };
}
