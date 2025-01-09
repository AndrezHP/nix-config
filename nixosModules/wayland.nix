{ pkgs, inputs, ... }:

{
  environment.systemPackages = with pkgs; [
    waybar # Wayland bar
    wl-clipboard # Wayland clipboard functionality
    rofi-wayland # Menu
    swww # Wayland wallpaper manager
  ];

   # Make electron apps use wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  services.xserver = {
    enable = true;
    displayManager = {
      gdm.enable = true;
      gdm.wayland = true;
    };
    # displayManager = {
    #   sddm.enable = true;
    #   sddm.wayland.enable = true;
    #   # sddm.theme = "${import ../pkgs/sddm-theme.nix { inherit pkgs; }}";
    # };

  };

  # Enable hyprland (mutually exclusive with gnome)
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    package = inputs.hyprland.packages."${pkgs.system}".hyprland; 
  };

}
