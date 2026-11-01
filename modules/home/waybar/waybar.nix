{ lib, config, ... }:
with lib;
let
  cfg = config.homeModules.waybar;
in
{
  options.homeModules.waybar.enable = mkEnableOption "Enable waybar";
  config = mkIf cfg.enable {
    programs.waybar = {
      enable = true;
      systemd.enable = false;
      style = ./style.css;
      settings = lib.importJSON ./config.jsonc;
    };
  };
}
