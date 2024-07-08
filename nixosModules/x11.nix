{ pkgs, ... }:

{ 
  environment.pathsToLink = [ "/libexec" ]; # links /libexec from derivations to /run/current-system/sw 

  services.xserver = {
    enable = true;

    desktopManager = {
      xterm.enable = false;
    };

    # displayManager = {
    #     defaultSession = "none+i3";
    # };

    displayManager = {
       sddm.enable = true;
       sddm.wayland.enable = true;
       sddm.theme = "${import ../pkgs/sddm-theme.nix { inherit pkgs; }}";
    };

    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu # application launcher most people use
        i3status # gives you the default i3 status bar
        i3lock # default i3 screen locker
        i3blocks # if you are planning on using i3blocks over i3status
     ];
    };
  };
}
