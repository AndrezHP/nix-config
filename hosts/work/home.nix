{ pkgs, ... }:
let
  formatScript = (
    pkgs.writeShellScriptBin "cf" ''
      # Format and then check linting or checkstyle
      if [ -f package.json ]; then
        npx prettier --print-width 100 --tab-width 2 --quote-props as-needed --trailing-comma es5 --bracket-same-line --prose-wrap preserve -w src
        if grep -q relay package.json; then
          npm run relay
        fi
        npx eslint src --max-warnings 0
      fi

      if [ -f pom.xml ]; then
        mvn spotless:apply
        mvn checkstyle:check
      fi
      if [ -f ./java/pom.xml ]; then
        (cd java && mvn spotless:apply ; mvn checkstyle:check)
      fi
    ''
  );
  jrun = (
    pkgs.writeShellScriptBin "jrun" ''
      mvn dependency:build-classpath -Dmdep.includeScope=runtime -Dmdep.outputFile=deps.txt
      DEPS=$(cat deps.txt)
      rm deps.txt
      CONFIGURATOR=$(head -n1 $(find ./src/main/java/ -name 'Configurator.java') | tr -d ';' | cut -d ' ' -f2 | awk '{print $1".Configurator"}');
      java -cp "./target/classes:$DEPS" com.secata.tools.rest.RestRunner $CONFIGURATOR
    ''
  );
  scripts = import ../../pkgs/scripts.nix { inherit pkgs; };
in
{
  imports = [
    ../../modules/home
    # ./nexus.nix
  ];

  nixpkgs = {
    overlays = [ ];
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  home.packages = with pkgs; [
    ##### Things for work development
    (pkgs.makeDesktopItem {
      name = "android-studio";
      desktopName = "Android Studio";
      exec = "android-studio";
    })
    gcc
    libgcc
    openjdk17-bootstrap # OpenJDK
    fnm # Fast Node version manager
    watchman # Required for relay
    maven # Instead of getting it from sdkman
    jq # like sed, but for JSON
    git
    # rustc
    # cargo
    # rustup
    openssl
    formatScript
    jrun
    (pkgs.callPackage ../../pkgs/cargo-pbc.nix { })

    ##### Other stuff
    jetbrains-toolbox
    spotify
    tidal-hifi
    discord
    libreoffice
    gimp # Gnu image manipulation program
    brave # Another browser
    tealdeer # tldr command
    kanata # Keyboard remapping

    yazi
    signal-desktop
    porsmo

    pavucontrol
    blueman # Bluetooth manager
    solaar # Manager for Logitech Unifying Receiver

    eza # better ls?
    zoxide # better file path navigation
    neofetch
    ffmpeg
    zathura # PDF viewer
    fzf
    lazydocker
    lazygit
    scripts.nixSearch
  ];

  xdg.configFile."kitty/kitty.conf".source = ../../modules/home/kitty/kitty.conf;
  xdg.configFile."kitty/theme.conf".source = ../../modules/home/kitty/theme.conf;
  homeModules = {
    emacs.enable = true;
    tmux.enable = true;
    nvimConfig = {
      enable = true;
      setBuildEnv = true;
      withBuildTools = true;
    };
    zsh = {
      enable = true;
      extraAliases = {
        bh = "home-manager switch --flake ~/nix-config/#work";
        sport = "sudo ss -tulwn | fzf";
      };
      initExtra = ''
        export GITLAB_PRIVATE_TOKEN=$(cat ~/.glpt)
        export PATH="/home/andreas/.rd/bin:$PATH"
        export PATH="/home/andreas/.emacs.d/bin:$PATH"
        export PATH="/home/andreas/bin:$PATH"
        export PATH="$HOME/.cargo/bin:$PATH"
        if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
            PATH="$HOME/.local/bin:$HOME/bin:$PATH"
        fi
        export PATH
      '';
    };
  };

  xdg.configFile."rofi".source = ../../dotfiles/rofi;
  programs.home-manager.enable = true;

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
