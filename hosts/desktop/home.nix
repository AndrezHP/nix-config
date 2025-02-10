{ lib, config, inputs, pkgs, ... }: {
  imports = [
    ../../homeModules/zsh.nix
    ../../homeModules/firefox.nix
    ../../homeModules/waybar.nix
    ../../homeModules/nvim/nvim.nix
    ../../homeModules/git.nix
    ../../homeModules/tmux.nix
    ../../homeModules/theme.nix
    ../../homeModules/app_packs.nix
    inputs.ags.homeManagerModules.default
  ];


  wayland.windowManager.hyprland.settings.general."col.active_border" = 
    lib.mkForce "rgb(${config.stylix.base16Scheme.base0E})";

  programs.ags = {
    enable = true;
    configDir = ../../dotfiles/ags;
    extraPackages = with pkgs; [
      gtksourceview
      webkitgtk
      accountsservice
    ];
  };

  packs = {
    games.enable = true;
    cliTools.enable = true;
    cyberTools.enable = true;
  };

  programs.swaylock = {
    enable = true;
    settings = {
      image = "~/nix-config/dotfiles/wallpapers/garden.png";
      daemonize = true;
      ignore-empty-password = true;
    };
  };

  programs.home-manager.enable = true;
  programs.nushell.enable = true;
  programs.neovim.nvimdots = {
    enable = true;
    setBuildEnv = true;
    withBuildTools = true;
  };

  nixpkgs = {
    overlays = [];
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
  xdg.configFile."kitty".source = ../../dotfiles/kitty;

  # Add stuff for your user as you see fit:
  home.packages = with pkgs; [
    alacritty
    wezterm
    ghostty
    kitty
    st
  ];

  services.syncthing.enable = true;

  xdg = {
    enable = true;
    mimeApps.defaultApplications = {
      "application/pdf" = ["zathura.desktop"];
      "image/*" = ["sxiv.desktop"];
      "video/png" = ["mpv.desktop"];
      "video/jpg" = ["mpv.desktop"];
      "video/*" = ["mpv.desktop"];
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
