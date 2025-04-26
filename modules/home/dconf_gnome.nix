{ config, lib, ... }:
with lib; let
  cfg = config.homeModules.dconf;
in
{
  options.homeModules.dconf.enable = mkEnableOption "Enable dconf, only relevant if using gnome";
  config = mkIf cfg.enable {
    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
      "org/gnome/desktop/background" = {
        picture-uri = "file:///home/andreas/nix-config/home-manager/wallpapers/chihiro-sea.jpg";
        picture-uri-dark = "file:///home/andreas/nix-config/home-manager/wallpapers/chihiro-sea.jpg";
      };
      "org/gnome/desktop/wm/keybindings" = {
        close = ["<Super>q"];
      };
      "org/gnome/desktop/peripherals/touchpad" = {
        tap-to-click = true;
      };
      "org/gnome/settings-daemon/plugins/media-keys" = {
        custom-keybindings = [
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
        ];
      };
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
        name = "Console";
        command = "alacritty";
        binding = "<Super>Return";
      };
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
        name = "Open Firefox";
        command = "firefox";
        binding = "<Super>w";
      };
    };
  };
}
