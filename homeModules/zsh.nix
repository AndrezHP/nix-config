{ ... }:

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
      theme = "bira";
      extraConfig = ''
        CASE_SENSITIVE="true"
      '';
    };
    shellAliases = {
      vim = "nvim";
    };
  };
}
