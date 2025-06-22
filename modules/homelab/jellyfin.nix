{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.homelab.jellyfin;
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
        href = "http://192.168.1.223:8096";
        siteMonitor = "http://localhost:8096";
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
      openFirewall = true;
      user = "andreas";
    };
  };
}
