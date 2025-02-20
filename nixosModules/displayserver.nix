{ pkgs, lib, inputs, config, ... }:
with lib; let
  cfg = config.nixosModules.displayServer;

  waylandConfig = {
    environment.systemPackages = with pkgs; [
      waybar # Wayland bar
      wl-clipboard # Wayland clipboard functionality
      rofi-wayland # Menu
      hyprpaper
    ];
     # Make electron apps use wayland
    environment.sessionVariables.NIXOS_OZONE_WL = "1";
    services.xserver = {
      enable = true;
      displayManager = {
        gdm.enable = true;
        gdm.wayland = true;
      };
    };
    # Enable hyprland (mutually exclusive with gnome)
    programs.hyprland = mkIf cfg.wayland.hyprland.enable {
      enable = true;
      xwayland.enable = true;
      # withUWSM = true; # if you want to have several wayland compositors
      package = inputs.hyprland.packages."${pkgs.system}".hyprland; 
    };
  };

  x11Config = {
    environment.pathsToLink = [ "/libexec" ]; # links /libexec from derivations to /run/current-system/sw 
    environment.plasma5.excludePackages = with pkgs.libsForQt5; [
      plasma-browser-integration
      konsole
      oxygen
    ];
    hardware.pulseaudio.enable = true;
    programs.dconf.enable = true;
    services.xserver = {
      enable = true;
      displayManager.sddm.enable = true;
      desktopManager.plasma5.enable = true;

      windowManager.i3 = mkIf cfg.x11.i3.enable {
        enable = true;
        extraPackages = with pkgs; [
          dmenu # application launcher most people use
          i3status # gives you the default i3 status bar
          i3lock # default i3 screen locker
          i3blocks # if you are planning on using i3blocks over i3status
       ];
      };
    };
  };
in
{
  options.nixosModules.displayServer = {
    wayland = {
      enable = mkEnableOption "Enable wayland";
      hyprland.enable = mkEnableOption "Enable Hyprland";
    };
    x11 = {
      enable = mkEnableOption "Enable x11";
      i3.enable = mkEnableOption "Enable i3";
      kde.enable = mkEnableOption "Enable KDE Plasma";
    };
  };
  config = lib.mkMerge [
    (mkIf cfg.wayland.enable waylandConfig)
    (mkIf cfg.x11.enable x11Config)
  ];
}
