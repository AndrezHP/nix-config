{ config, lib, ... }:
let
  cfg = config.homeModules.hyprlandConfig;
in
{
  options.homeModules.hyprlandConfig = {
    enable = lib.mkEnableOption "Enable git with configuration";
    additionalConfig = lib.mkOption {
      type = lib.types.str;
      default = ''
        hl.monitor({ output = "HDMI-A-1", mode = "2560x1440@144", position = "2560x0", scale = 1 })
        hl.monitor({ output = "DP-3", mode = "2560x1440@60", position = "0x0", scale = 1 })

        hl.workspace_rule({ workspace = "1", monitor = "HDMI-A-1", default = true })
        hl.workspace_rule({ workspace = "2", monitor = "HDMI-A-1" })
        hl.workspace_rule({ workspace = "3", monitor = "DP-3" })
        hl.workspace_rule({ workspace = "4", monitor = "DP-3" })
        hl.workspace_rule({ workspace = "7", monitor = "HDMI-A-1" })
        hl.workspace_rule({ workspace = "8", monitor = "HDMI-A-1" })
        hl.workspace_rule({ workspace = "9", monitor = "HDMI-A-1" })
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    xdg.configFile."hypr/hyprlock.conf".source = ../../dotfiles/hypr/hyprlock.conf;
    xdg.configFile."hypr/hyprpaper.conf".source = ../../dotfiles/hypr/hyprpaper.conf;
    xdg.configFile."hypr/switch-keyboard-layout.sh".source =
      ../../dotfiles/hypr/switch-keyboard-layout.sh;

    wayland.windowManager.hyprland = {
      enable = true;
      systemd.enable = false;
      configType = "lua";
      extraConfig = cfg.additionalConfig + builtins.readFile ../../dotfiles/hypr/hyprland.lua;
    };
  };
}
