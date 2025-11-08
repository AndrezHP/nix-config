{ config, lib, ... }:
with lib;
let
  cfg = config.homeModules.btop;
in
{
  options.homeModules.btop.enable = mkEnableOption "Enable btop with configuration";
  config = mkIf cfg.enable {
    programs.btop.enable = true;
    xdg.configFile."btop/btop.conf".source = ./btop.conf;
    xdg.configFile."btop/themes/current.theme".source = ./btop.theme;
    homeModules.zsh.extraAliases = mkIf config.homeModules.btop.enable {
      htop = "btop";
    };
  };
}
