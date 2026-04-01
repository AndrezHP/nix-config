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
        $monitor1 = HDMI-A-1
        $monitor2 = DP-1

        monitor=$monitor2, 1920x1080@60, 0x0, 1
        workspace=$monitor2,1
        monitor=$monitor1, 2560x1440@144, 1920x0, 1
        workspace=$monitor1,2

        # Workspace binding
        workspace=1, monitor:$monitor1
        workspace=2, monitor:$monitor1
        workspace=3, monitor:$monitor2
        workspace=4, monitor:$monitor2
        workspace=6, monitor:$monitor1
        workspace=8, monitor:$monitor1
        workspace=9, monitor:$monitor1
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
      plugins = [ ];
      settings = { };
      extraConfig = cfg.additionalConfig + builtins.readFile ../../dotfiles/hypr/hyprland.conf;
    };
  };
}
