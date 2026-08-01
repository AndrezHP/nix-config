{
  config,
  pkgs,
  ...
}:
let
  scripts = import ../../pkgs/scripts.nix { inherit pkgs; };
in
{
  imports = [ ../../modules/home ];

  home.packages = with pkgs; [
    jetbrains.idea
    (haskellPackages.ghcWithPackages (pkgs: with pkgs; [ stack ]))
    # (python312.withPackages (
    #   p: with p; [
    #     numpy
    #     pandas
    #     scipy
    #     matplotlib
    #     requests
    #     seaborn
    #     beautifulsoup4
    #   ]
    # ))
    cifs-utils # Used for mounting smb shares
    sqlite
    alacritty
    kitty
    hyprlock
    hypridle
    nwg-look
    go
    cemu # Wii U Emulation
    ryubing # Switch Emulation
    scripts.gamemode
    scripts.mountSamba
    scripts.takeScreenshot
    scripts.nixSearch
    scripts.nixClean
    handbrake
    vlc
    makemkv
    mkvtoolnix # Matroska tools for Linux/Unix
    feishin # Client for self hosted music streaming
    odin
    ols
    tree-sitter
    gcc
    reaper
    alsa-lib
    jack2
    vscodium
    jetbrains-toolbox
    pv # Tool for monitoring the progress of data through a pipeline
    opencode
    clojure
    clojure-lsp
    clj-kondo
    cljfmt
    jre25_minimal
    gdu

    # These might be useful for setting up oauth for mail
    # oama # OAuth credential manager
    # cyrus-sasl-xoauth2
  ];

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };
  };

  homeModules = {
    btop.enable = true;
    wlogout.enable = true;
    waybar.enable = true;
    git.enable = true;
    zsh = {
      enable = true;
      extraAliases = {
        bh = "home-manager switch --flake ~/nix-config/#desktop";
        bs = "sudo nixos-rebuild switch --flake ~/nix-config#desktop";
      };
      initExtra = ''
        export PATH=$PATH:$(go env GOPATH)/bin
        export PATH="/home/andreas/.emacs.d/bin:$PATH"
        export ANDROID_HOME=$HOME/Android/Sdk
        export LADSPA_PATH=/usr/lib/ladspa:
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
      basics.enable = true;
      cliTools.enable = true;
      cyberTools.enable = false;
      games.enable = true;
    };
  };

  homeModules.hyprlandConfig = {
    enable = true;
    additionalConfig = ''
      hl.monitor({ output = "HDMI-A-1", mode = "2560x1440@144", position = "2560x0", scale = 1 })
      hl.monitor({ output = "DP-3", mode = "2560x1440@60", position = "0x0", scale = 1 })

      hl.workspace_rule({ workspace = "1", monitor = "HDMI-A-1", default = true })
      hl.workspace_rule({ workspace = "2", monitor = "HDMI-A-1" })
      hl.workspace_rule({ workspace = "3", monitor = "DP-3" })
      hl.workspace_rule({ workspace = "4", monitor = "DP-3" })
      hl.workspace_rule({ workspace = "7", monitor = "HDMI-A-1" })
      hl.workspace_rule({ workspace = "8", monitor = "HDMI-A-1" })
      hl.workspace_rule({ workspace = "9", monitor = "HDMI-A-1" })
    '';
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
    userDirs = {
      enable = true;
      setSessionVariables = true;
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
