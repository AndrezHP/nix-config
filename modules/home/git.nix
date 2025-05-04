{ lib, config, ... }:
let
  cfg = config.homeModules.git;
in
{
  options.homeModules.git.enable = lib.mkEnableOption "Enable git with configuration";
  config = lib.mkIf cfg.enable {
    programs.git = {
      enable = true;
      userName = "AndrezHP";
      userEmail = "usermail@mail.com";
      extraConfig = {
        init.defaultBranch = "main";
      };
    };
  };
}
