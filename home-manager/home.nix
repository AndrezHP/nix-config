# This is your home-manager configuration file
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
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
  ];

  nixpkgs = {
    # You can add overlays here
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
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "andreas";
    homeDirectory = "/home/andreas";
  };

  # Allow electron version 25.9.0
  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0"
  ];

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  home.packages = with pkgs; [
    # User Applications
    obsidian
    kodi-wayland
    qbittorrent
    signal-desktop
    keepassxc
    ani-cli
    discord
    syncthing
    spotify
    
    # Terminals to try out
    wezterm
    alacritty
    kitty

    jetbrains-toolbox

    # Virtualization 
    qemu
    virt-manager
    
    # Games
    steam
    steam-run
    runelite
    lutris-unwrapped

    # Music
    musescore
    reaper
  ];

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git = { 
    enable = true;
    userName = "andreas";
    userEmail = "usermail@mail.com";
  };

  gtk = {
    enable = true;
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
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
    "org/gnome/desktop/background" = {
      picture-uri = "file:///home/andreas/nix-config/home-manager/wallpapers/wallhaven-car.jpg";
      picture-uri-dark = "file:///home/andreas/nix-config/home-manager/wallpapers/wallhaven-car.jpg";
    };
    "org/gnome/desktop/wm/keybindings" = {
      close = ["<Super>q"];
    };
    "org/gnome/desktop/peripherals/touchpad" = {
      tap-to-click = true;
    };
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
      ];
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      name = "Console";
      command = "alacritty";
      binding = "<Super>Return";
    };
  };

  services.syncthing.enable = true;

  programs.zsh = {
    enable = true;
    autocd = true;
    enableAutosuggestions = true;
    #enableCompletion = true;
    syntaxHighlighting.enable = true;
    history.size = 10000;
    prezto.caseSensitive = true;
    oh-my-zsh = {
      enable = true;
      #theme = "aussiegeek";
      #theme = "alanpeabody";
      theme = "bira";
      #theme = "half-life";
      plugins = [
        "git"
        "history"
        "rust"
      ];
      extraConfig = ''
        CASE_SENSITIVE="true"
      '';
    };
    shellAliases = {
      vim = "nvim";
    };
  };

  xdg.enable = true;
  xdg.userDirs = {
    enable = true;
    music = "${config.home.homeDirectory}/Media/Music";
    videos = "${config.home.homeDirectory}/Media/Videos";
    pictures = "${config.home.homeDirectory}/Media/Pictures";
    download = "${config.home.homeDirectory}/Downloads";
    documents = "${config.home.homeDirectory}/Documents";
    desktop = null;
    };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
