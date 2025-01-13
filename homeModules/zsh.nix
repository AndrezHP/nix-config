{pkgs, ...}: {
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
    shellAliases = {
      vim = "nvim";
      lg = "lazygit";
      conf = "cd ~/nix-config && nvim";
      bh = "home-manager switch --flake ~/nix-config/#default";
      bs = "sudo nixos-rebuild switch --flake ~/nix-config#default";
      dev-rust = "nix-shell ~/nix-config/rust-shell/shell.nix";
    };
  };
}
