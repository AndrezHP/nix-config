{ pkgs, ... }:
let
  formatScript = (
    pkgs.writeShellScriptBin "cf" ''
      # Format
      if [ -f package.json ]; then
        npx prettier --print-width 100 --tab-width 2 --quote-props as-needed --trailing-comma es5 --bracket-same-line --prose-wrap preserve -w src
      fi
      if [ -f pom.xml ]; then
        mvn spotless:apply
      fi

      # Check some linting or checkstyle
      if [ -f package.json ]; then
        if grep -q relay package.json; then
          npm run relay
        fi
        npx eslint src --max-warnings 0
      fi
      if [ -f pom.xml ]; then
        mvn checkstyle:check
      fi
    ''
  );
in
{
  imports = [
    ../../modules/home
    ./cargo-pbc.nix
    # ./nexus.nix
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

  xdg.configFile."kitty/kitty.conf".source = ../../modules/home/kitty/kitty.conf;
  xdg.configFile."kitty/theme.conf".source = ../../modules/home/kitty/theme.conf;
  homeModules = {
    emacs.enable = true;
    zsh = {
      enable = true;
      extraAliases = {
        bh = "home-manager switch --flake ~/nix-config/#work";
        pbc = "cargo-pbc pbc";
      };
      initExtra = ''
        export GITLAB_PRIVATE_TOKEN=$(cat ~/.glpt)
        export PATH="/home/andreas/.rd/bin:$PATH"
        export PATH="/home/andreas/.emacs.d/bin:$PATH"
        export PATH="/home/andreas/bin:$PATH"
        if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
            PATH="$HOME/.local/bin:$HOME/bin:$PATH"
        fi
        export PATH
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
    ##### Things for work development
    # (pkgs.jetbrains.plugins.addPlugins pkgs.jetbrains.idea-ultimate [
    #   "google-java-format"
    #   "intellij.prettierJS"
    #   "IdeaVIM"
    #   "com.intellij.lang.jsgraphql"
    # ])
    gcc
    libgcc
    openjdk17-bootstrap # OpenJDK
    fnm # Fast Node version manager
    watchman # Required for relay
    maven # Instead of getting it from sdkman
    jq # like sed, but for JSON
    git
    # rustup
    # rustc
    # cargo
    formatScript

    ##### Other stuff
    jetbrains-toolbox
    spotify
    discord
    libreoffice
    gimp # Gnu image manipulation program
    brave # Another browser
    tealdeer # tldr command
    kanata # Keyboard remapping

    pavucontrol
    blueman # Bluetooth manager
    solaar # Manager for Logitech Unifying Receiver

    eza # better ls?
    zoxide # better file path navigation
    neofetch
    ffmpeg
    zathura # PDF viewer
  ];

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
