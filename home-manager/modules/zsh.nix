{ inputs, pkgs, lib, config, ... }:

{ 
  programs.zsh = { 
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    history.size = 10000;
    prezto.caseSensitive = true;
    oh-my-zsh = {
      enable = true;
      #theme = "aussiegeek";
      #theme = "alanpeabody";
      theme = "bira";
      #theme = "half-life";
      extraConfig = ''
        CASE_SENSITIVE="true"
      '';
    };
    shellAliases = {
      vim = "nvim";
    };
  };
}
