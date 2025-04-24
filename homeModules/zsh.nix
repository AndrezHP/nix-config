{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.homeModules.zsh;
in
{
  options.homeModules.zsh = {
    enable = mkEnableOption "Enable zsh config";
    extraAliases = mkOption {
      type = with types; attrs;
      description = "Extra shell aliases for zsh";
      default = { };
    };
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [ direnv ];
    programs.zsh = {
      enable = true;
      autosuggestion.enable = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;
      history.size = 10000;
      prezto.caseSensitive = true;
      oh-my-zsh = {
        enable = true;
        theme = "bira";
        extraConfig = ''
          CASE_SENSITIVE="true"
        '';
        plugins = [ "direnv" ];
      };
      shellAliases = lib.mkMerge [
        cfg.extraAliases
        {
          vim = "nvim";
          lg = "lazygit";
          conf = "cd ~/nix-config && nvim";
          dev-rust = "nix-shell ~/nix-config/rust-shell/shell.nix";
          lf = mkIf (elem pkgs.yazi config.home.packages) "yazi";
        }
      ];
    };
  };
}
