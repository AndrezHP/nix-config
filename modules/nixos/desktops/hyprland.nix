{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.nixosModules.desktops.hyprland;
in
{
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      waybar # Wayland bar
      wl-clipboard # Wayland clipboard functionality
      rofi # Menu
      hyprpaper
      hyprpicker
    ];

    # Make electron apps use wayland
    environment.sessionVariables.NIXOS_OZONE_WL = "1";
    services.xserver.enable = true;
    services.displayManager = {
      gdm.enable = true;
      gdm.wayland = true;
      gdm.autoSuspend = false;
    };

    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
      # withUWSM = true; # if you want to have several wayland compositors
      package = inputs.hyprland.packages."${pkgs.system}".hyprland;
    };
  };
}
