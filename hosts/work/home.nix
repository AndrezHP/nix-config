{ pkgs, ... }:
{
  imports = [
    ../../modules/home
  ];

  xdg.configFile."kitty/kitty.conf".source = ../../modules/home/kitty/kitty.conf;
  xdg.configFile."kitty/theme.conf".source = ../../modules/home/kitty/theme.conf;
  homeModules = {
    emacs.enable = true;
    zsh = {
      enable = true;
      extraAliases = {
        bh = "home-manager switch --flake ~/nix-config/#work";
      };
      initExtra = ''
        if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
            PATH="$HOME/.local/bin:$HOME/bin:$PATH"
        fi
        export PATH

        export GITLAB_PRIVATE_TOKEN=$(cat ~/.glpt)

        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
        [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
        . "$HOME/.cargo/env"

        export PATH="/home/andreas/.rd/bin:$PATH"
        export PATH="/home/andreas/.emacs.d/bin:$PATH"
        export PATH="/home/andreas/bin:$PATH"

        export SDKMAN_DIR="$HOME/.sdkman"
        [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
      '';
    };
    nvimConfig = {
      enable = true;
      setBuildEnv = true;
      withBuildTools = true;
    };
  };

  xdg.configFile."rofi".source = ../../dotfiles/rofi;
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    jetbrains-toolbox
    gcc
    watchman
    lazygit

    kanata

    spotify
    discord

    mpd # Music Player Daemon
    pavucontrol
    blueman # Bluetooth manager
    solaar # Manager for Logitech Unifying Receiver
    porsmo # Cli Pomodoro
    ncmpcpp # Music player
    lf
    yazi

    brave # Another browser
    calibre # E-book software
    zathura # PDF viewer
    sxiv # Image viewer

    libreoffice
    gimp # Gnu image manipulation program

    ffmpeg
    eza # better ls?
    zoxide # better file path navigation
    tealdeer # tldr command
    jq # like sed, but for JSON
    lazygit
    neofetch
    openjdk17-bootstrap
  ];

  nixpkgs = {
    overlays = [ ];
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "andreas";
    homeDirectory = "/home/andreas";
    sessionVariables = {
      EDITOR = "nvim";
    };
  };

  systemd.user.startServices = "sd-switch";
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
