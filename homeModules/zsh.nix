{pkgs, lib, config, ...}:
with lib; let
  cfg = config.homeModules.zsh;
in
{
  options.homeModules.zsh.enable = mkEnableOption "Enable zsh config";
  config = mkIf cfg.enable {
    home.packages = with pkgs; [direnv];
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
        plugins = ["direnv"];
      };
      plugins = [
          {
            name = "vi-mode";
            src = pkgs.zsh-vi-mode;
            file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
          }
      ];

      shellAliases = {
        vim = "nvim";
        lg = "lazygit";
        conf = "cd ~/nix-config && nvim";
        bh = "home-manager switch --flake ~/nix-config/#default";
        bs = "sudo nixos-rebuild switch --flake ~/nix-config#default";
        dev-rust = "nix-shell ~/nix-config/rust-shell/shell.nix";
        lf = lib.mkIf (lib.elem pkgs.yazi config.home.packages ) "yazi";
      };
    };
  };
}
