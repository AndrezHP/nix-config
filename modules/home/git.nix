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
        user = {
          name = "AndrezHP";
          email = "usermail@mail.com";
        };
        alias = {
          ch = "checkout";
          br = "branch";
          st = "status";
          cm = "commit";
        };
        init.defaultBranch = "main";
        push.autoSetupRemote = true;
        pull.rebase = true;
      };
    };
  };
}
