{ pkgs, lib, inputs, config, ... }: 
let 
  waylandConfig = {
    environment.systemPackages = with pkgs; [
      waybar # Wayland bar
      wl-clipboard # Wayland clipboard functionality
      rofi-wayland # Menu
      swww # Wayland wallpaper manager
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
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
      # withUWSM = true; # if you want to have several wayland compositors
      package = inputs.hyprland.packages."${pkgs.system}".hyprland; 
    };
  };
  x11Config = {
    environment.pathsToLink = [ "/libexec" ]; # links /libexec from derivations to /run/current-system/sw 

    services.xserver = {
      enable = true;

      desktopManager = {
        xterm.enable = false;
      };

      displayManager = {
        gdm.enable = true;
        gdm.wayland = true;
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
  };
in
{
  options.env = { 
    displayServer = lib.mkOption {
        type = lib.types.str;
        default = "wayland";
        example = "x11";
        description = "Pick either \"wayland\" or \"x11\" here";
      };
      windowManager = {
        type = lib.types.str;
        default = "hyprland";
      };
      desktop = {
        enable = lib.mkDefault false;
    };
  };

  config = lib.mkMerge [
    (lib.mkIf ( config.env.displayServer == "wayland" ) waylandConfig)
    (lib.mkIf ( config.env.displayServer == "x11" ) x11Config)
  ];
}
