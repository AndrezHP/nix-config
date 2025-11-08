{ lib, config, ... }:
let
  cfg = config.homeModules.git;
in
{
  options.homeModules.git.enable = lib.mkEnableOption "Enable git with configuration";
  config = lib.mkIf cfg.enable {
    programs.git = {
      enable = true;
      settings = {
        init.defaultBranch = "main";
        user.name = "AndrezHP";
        user.email = "usermail@mail.com";
      };
    };
  };
}
