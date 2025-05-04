{ pkgs, ... }:
{
  imports = [
    ../../modules/home
  ];

  homeModules = {
    emacs.enable = true;
    zsh = {
      enable = true;
      extraAliases = {
        bh = "home-manager switch --flake ~/nix-config/#work";
      };
      initExtra = ''
        export SDKMAN_DIR="$HOME/.sdkman"
        [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
      '';
    };
    kitty.enable = true;
    nvimConfig = {
      enable = true;
      setBuildEnv = true;
      withBuildTools = true;
    };
    applications = {
      cliTools.enable = true;
      devTools.enable = true;
    };
  };

  xdg.configFile."rofi".source = ../../dotfiles/rofi;
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    jetbrains-toolbox
    gcc
    pgadmin4
    pgadmin4
    watchman
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
