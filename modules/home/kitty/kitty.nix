{ config, lib, ...}:
with lib; let
  cfg = config.homeModules.kitty;
in {
  options.homeModules.kitty.enable = mkEnableOption "Enable kitty with configuration";
  config = mkIf cfg.enable {
    programs.kitty = {
      enable = true;
    };
    xdg.configFile."kitty/kitty.conf".source = ./kitty.conf;
    xdg.configFile."kitty/theme.conf".source = ./theme.conf;
  };
}

