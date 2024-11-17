# This is your home-manager configuration filedhom
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
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
    ../../homeModules/git.nix
    ../../homeModules/tmux.nix
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule
  ];

  programs.neovim.nvimdots = {
    enable = true;
    setBuildEnv = true;
    withBuildTools = true;
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
    # dolphin # File manager
    xfce.thunar
    xfce.thunar-volman
    ranger
    brave # Another browser
    newsflash # RSS reader
    zathura # PDF viewer
    sxiv # Image viewer
    jetbrains-toolbox
    spotify
    musescore # Sheet music editor
    # reaper # Digital audio workstation
    # kodi-wayland

    stylua
    rust-analyzer
    nil

    # Terminals
    wezterm
    alacritty

    # Virtualization 
    qemu
    virt-manager
    wine # Windows compatibility
    lazygit

    # Games
    steam
    steam-run
    runelite
    lutris-unwrapped
    bottles-unwrapped
    heroic-unwrapped
  ];

  services.syncthing.enable = true;

  # Enable home-manager
  programs.home-manager.enable = true;

  gtk = {
    enable = true;
    theme.package = pkgs.adw-gtk3;
    theme.name = "adw-gtk3";
    cursorTheme.package = pkgs.bibata-cursors;
    cursorTheme.name = "Bibata-Modern-Ice";
    iconTheme.package = pkgs.papirus-icon-theme;
    iconTheme.name = "Papirus";
    gtk3.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
    gtk4.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
  };
  home.sessionVariables.GTK_THEME = "palenight";

  qt = {
    enable = true;
    platformTheme = "gtk";
    style.name = "adwaita-dark";
    style.package = pkgs.adwaita-qt;
  };

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
