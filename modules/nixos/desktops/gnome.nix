{
  config,
  lib,
  ...
}:
let
  cfg = config.nixosModules.desktops.gnome;
in
{
  config = lib.mkIf cfg.enable {
    environment.pathsToLink = [ "/libexec" ]; # links /libexec from derivations to /run/current-system/sw
    hardware.pulseaudio.enable = true;
    programs.dconf.enable = true;

    services.xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };
  };
}
