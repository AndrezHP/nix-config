{ config, pkgs, ... }:
{
  imports = [
    ../../homeModules
  ];

  homeModules = {
    wlogout.enable = true;
    waybar.enable = true;
    zsh.enable = true;
    firefox.enable = true;
    tmux.enable = true;
    theme.enable = true;
    emacs.enable = true;
    kitty.enable = true;
    nvimConfig = {
      enable = true;
      setBuildEnv = true;
      withBuildTools = true;
    };
    applications = {
      cliTools.enable = true;
      cyberTools.enable = true;
      games.enable = true;
      games.modernEmulation.enable = true;
    };
  };

  programs.home-manager.enable = true;
  programs.nushell.enable = true;

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

  # Import dotfile configs
  xdg.configFile."hypr".source = ../../dotfiles/hypr;
  xdg.configFile."dunst".source = ../../dotfiles/dunst;
  xdg.configFile."rofi".source = ../../dotfiles/rofi;

  services.syncthing.enable = true;
  services.hypridle = {
    settings = {
      general = {
        after_sleep_cmd = "hyprctl dispatch dpms on";
        ignore_dbus_inhibit = false;
        lock_cmd = "hyprlock";
      };
      listener = [
        {
          timeout = 900;
          on-timeout = "hyprlock";
        }
        {
          timeout = 1200;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
      ];
    };
  };

  # Add stuff for your user as you see fit:
  home.packages = with pkgs; [
    sqlite
    alacritty
    kitty
    hyprlock
    hypridle
    hyprshot
    nwg-look
    (python312.withPackages (
      p: with p; [
        numpy
        pandas
        scipy
        matplotlib
        requests
        seaborn
        beautifulsoup4
      ]
    ))
    (haskellPackages.ghcWithPackages (pkgs: with pkgs; [ stack ]))
    (pkgs.writeShellScriptBin "gamemode" ''
      HYPRGAMEMODE=$(hyprctl getoption animations:enabled | awk 'NR==1{print $2}')
      if [ "$HYPRGAMEMODE" = 1 ] ; then
          hyprctl --batch "\
              keyword animations:enabled 0;\
              keyword decoration:shadow:enabled 0;\
              keyword decoration:blur:enabled 0;\
              keyword general:gaps_in 0;\
              keyword general:gaps_out 0;\
              keyword general:border_size 1;\
              keyword decoration:rounding 0"
          exit
      fi
      hyprctl reload
    '')
  ];

  xdg = {
    enable = true;
    mimeApps.defaultApplications = {
      "application/pdf" = [ "zathura.desktop" ];
      "image/*" = [ "sxiv.desktop" ];
      "video/png" = [ "mpv.desktop" ];
      "video/jpg" = [ "mpv.desktop" ];
      "video/*" = [ "mpv.desktop" ];
    };
    userDirs = {
      enable = true;
      music = "${config.home.homeDirectory}/Media/Music";
      videos = "${config.home.homeDirectory}/Media/Videos";
      pictures = "${config.home.homeDirectory}/Media/Pictures";
      download = "${config.home.homeDirectory}/Downloads";
      documents = "${config.home.homeDirectory}/Documents";
      desktop = null;
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
