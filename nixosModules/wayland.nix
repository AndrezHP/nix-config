{ pkgs, inputs, ... }: {
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
    # withUWSM = true; # if you want to have several wayland compositors
    package = inputs.hyprland.packages."${pkgs.system}".hyprland; 
  };

  programs.swaylock = {
    enable = true;
    settings = {
      image = "~/nix-config/dotfiles/wallpapers/garden.png";
      daemonize = true;
      ignore-empty-password = true;
    };
  };
}
