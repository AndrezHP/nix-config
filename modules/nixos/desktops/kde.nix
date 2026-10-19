{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixosModules.desktops.kde;
in
{
  config = lib.mkIf cfg.enable {
    environment.pathsToLink = [ "/libexec" ]; # links /libexec from derivations to /run/current-system/sw
    environment.plasma6.excludePackages = with pkgs.libsForQt5; [
      plasma-browser-integration
      konsole
      oxygen
    ];
    hardware.pulseaudio.enable = true;
    programs.dconf.enable = true;

    services.xserver.enable = true;
    services.displayManager.sddm.enable = true;
    services.desktopManager.plasma6.enable = true;
  };
}
