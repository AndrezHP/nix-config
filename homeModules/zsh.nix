{ pkgs, ... }:

{ 
  home.packages = with pkgs; [ direnv ];

  programs.zsh = { 
    enable = true;
    enableAutosuggestions = true;
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
    shellAliases = {
      vim = "nvim";
    };
  };
}
