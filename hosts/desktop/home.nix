# This is your home-manager configuration filedhom
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    ../../homeModules/zsh.nix
    ../../homeModules/firefox.nix
    ../../homeModules/waybar.nix
    ../../homeModules/nvim/nvim.nix
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule
    
    #./modules/dconf_gnome.nix
    # You can also split up your configuration and import pieces of it here:
  ];

  programs.neovim.nvimdots = {
    enable = true;
    setBuildEnv = true;
    withBuildTools = true;
    withHaskell = true;
  };

  nixpkgs = {
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
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

  # Import the hyprland configuration
  xdg.configFile."hypr".source = ../../dotfiles/hypr;
  xdg.configFile."dunst".source = ../../dotfiles/dunst;
  xdg.configFile."rofi".source = ../../dotfiles/rofi;

  # Allow electron version 25.9.0
  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0"
  ];

  # Add stuff for your user as you see fit:
  home.packages = with pkgs; [
    # User Applications
    obsidian # Notes
    qbittorrent
    signal-desktop # Private message app
    keepassxc # Offline password manager
    ani-cli
    webcord # Better discord
    syncthing # Synchronization between devices
    obs-studio
    calibre # E-book software
    dolphin # File manager
    brave # Another browser
    newsflash # RSS readers
    zathura # PDF viewer
    sxiv # Image viewer
    jetbrains-toolbox
    # kodi-wayland

    # nvim lsps/linters
    stylua
    rust-analyzer
    nil

    # Terminals
    wezterm
    alacritty
    kitty

    # Virtualization 
    qemu
    virt-manager
    wine # Windows compatibility

    # Games
    steam
    steam-run
    runelite
    lutris-unwrapped
    bottles-unwrapped
    heroic-unwrapped

    # Music
    spotify
    musescore
    # reaper # Digital audio workstation
  ];

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git = { 
    enable = true;
    userName = "andreas";
    userEmail = "usermail@mail.com";
    extraConfig = {

    };
  };

  programs.tmux = {
    enable = true;
    clock24 = true;
    baseIndex = 1;
    escapeTime = 1500;
    keyMode = "vi";

    plugins = [
      pkgs.tmuxPlugins.vim-tmux-navigator
      pkgs.tmuxPlugins.catppuccin
    ];

    extraConfig = ''
      set -g prefix C-s
      set -g mouse on
      set-option -g status-position top

      set -g @catppuccin_window_left_separator ""
      set -g @catppuccin_window_right_separator " "
      set -g @catppuccin_window_middle_separator " █"
      set -g @catppuccin_window_number_position "right"

      set -g @catppuccin_window_default_fill "number"
      set -g @catppuccin_window_default_text "#W"

      set -g @catppuccin_window_current_fill "number"
      set -g @catppuccin_window_current_text "#W"

      set -g @catppuccin_status_modules_right "directory session"
      set -g @catppuccin_status_left_separator  " "
      set -g @catppuccin_status_right_separator ""
      set -g @catppuccin_status_fill "icon"
      set -g @catppuccin_status_connect_separator "no"

      set -g @catppuccin_directory_text "#{pane_current_path}"

      bind-key h select-pane -L
      bind-key j select-pane -D
      bind-key k select-pane -U
      bind-key l select-pane -R

      bind C-p previous-window
      bind C-n next-window
    '';
  };

  gtk = {
    enable = true;
    theme.package = pkgs.adw-gtk3;
    theme.name = "adw-gtk3";
    cursorTheme.package = pkgs.bibata-cursors;
    cursorTheme.name = "Bibate-Modern-Ice";
    iconTheme.package = pkgs.papirus-icon-theme;
    iconTheme.name = "Papirus";
    # gtk3.extraConfig = {
    #   Settings = ''
    #     gtk-application-prefer-dark-theme=1
    #   '';
    # };
    # gtk4.extraConfig = {
    #   Settings = ''
    #     gtk-application-prefer-dark-theme=1
    #   '';
    # };
  };
  # home.sessionVariables.GTK_THEME = "palenight";

  qt.enable = true;
  qt.platformTheme = "gtk";
  qt.style.name = "adwaita-dark";

  services.syncthing.enable = true;

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
