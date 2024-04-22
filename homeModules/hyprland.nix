{ inputs, pkgs, ... }:

{ 
  wayland.windowManager.hyprland = {
    enable = true;
    plugins = [
      inputs.hyprland-plugins.packages."${pkgs.system}".borders-plus-plus
    ];
    settings = {};
  };
}
