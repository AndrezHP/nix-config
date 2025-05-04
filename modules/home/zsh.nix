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
    initExtra = mkOption {
      type = with types; string;
      description = "Extra config at the end of .zshrc";
      default = "";
    };
  };
  config = mkIf cfg.enable {
    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
      options = [ "--cmd cd" ];
    };
    programs.direnv = {
      enable = true;
      enableZshIntegration = true;
    };

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
      initContent = ''
        bindkey '^\b' backward-kill-word
      '';
      initExtra = cfg.extraInit;
      shellAliases = lib.mkMerge [
        cfg.extraAliases
        {
          lf = mkIf (elem pkgs.yazi config.home.packages) "yazi";
          ls = mkIf (elem pkgs.eza config.home.packages) "eza";
          vim = "nvim";
          lg = "lazygit";
          conf = "cd ~/nix-config && nvim";
          dev-rust = "nix-shell ~/nix-config/shells/rust/shell.nix";
          la = "ls --color -lha";
          df = "df -h";
        }
      ];
    };
  };
}
