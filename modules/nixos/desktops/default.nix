{
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.nixosModules.desktops;
in
{
  imports = [
    ./kde.nix
    ./i3.nix
    ./gnome.nix
    ./hyprland.nix
  ];

  options.nixosModules.desktops = {
    hyprland.enable = mkEnableOption "Enable Hyprland";
    i3.enable = mkEnableOption "Enable i3";
    kde.enable = mkEnableOption "Enable KDE Plasma";
    gnome.enable = mkEnableOption "Enable Gnome";
  };

  config = {
    assertions = [
      {
        assertion =
          (lib.length (
            lib.filter (x: x) [
              cfg.hyprland.enable
              cfg.i3.enable
              cfg.kde.enable
              cfg.gnome.enable
            ]
          )) <= 1;
        message = "Only one of nixosModules.desktops.kde/i3/hyprland/gnome can be enabled at the same time.";
      }
    ];
  };
}
