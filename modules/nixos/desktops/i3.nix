{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixosModules.desktops.i3;
in
{
  config = lib.mkIf cfg.enable {
    hardware.pulseaudio.enable = true;
    programs.dconf.enable = true;
    services.xserver = {
      enable = true;
      displayManager.sddm.enable = true;
      windowManager.i3 = {
        enable = true;
        extraPackages = with pkgs; [
          dmenu
          i3status
          i3lock # default i3 screen locker
          i3blocks # if you are planning on using i3blocks over i3status
        ];
      };
    };
  };
}
