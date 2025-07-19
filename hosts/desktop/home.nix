{
  config,
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    ../../modules/home
    inputs.zen-browser.homeModules.twilight-official
  ];

  home.packages = with pkgs; [
    cifs-utils
    (pkgs.jetbrains.plugins.addPlugins pkgs.jetbrains.idea-ultimate [
      # "google-java-format" # There are not bundled in nixpkgs
      # "intellij.prettierJS"
      "ideavim"
      "graphql"
    ])
    (pkgs.callPackage ../../pkgs/cargo-pbc.nix { })
    path-of-building
    sqlite
    alacritty
    kitty
    hyprlock
    hypridle
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
      ROUNDING=$(hyprctl getoption decoration:rounding | awk 'NR==1{print $2}')
      if [ "$ROUNDING" -gt 0 ] ; then
          hyprctl --batch "\
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
    (pkgs.writeShellScriptBin "mountSamba" ''
      read -p "User name: " USERNAME
      read -s -p "Password: " PASSWORD
      sudo mount -t cifs //192.168.1.223/public /mnt/samba_share -o username=$USERNAME,password=$PASSWORD,gid=1000,uid=$USERNAME
    '')
    go
    cemu
    ryujinx
    baobab # Disk usage analyzer
    (pkgs.writeShellScriptBin "takeScreenshot" ''
      ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" - |\
      ${pkgs.swappy}/bin/swappy -f - -o ~/Media/Screenshots/$(date | awk '{print $1}').png
    '')
  ];

  programs.zen-browser = {
    enable = true;
    policies = {
      DisableAppUpdate = true;
      DisableTelemetry = true;
      # find more options here: https://mozilla.github.io/policy-templates/
    };
  };

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };
  };

  homeModules = {
    wlogout.enable = true;
    waybar.enable = true;
    git.enable = true;
    zsh = {
      enable = true;
      extraAliases = {
        bh = "home-manager switch --flake ~/nix-config/#default";
        bs = "sudo nixos-rebuild switch --flake ~/nix-config#default";
      };
      initExtra = ''
        export PATH=$PATH:$(go env GOPATH)/bin
      '';
    };
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

  xdg = {
    enable = true;
    mimeApps.defaultApplications = {
      "application/pdf" = [ "zathura.desktop" ];
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
