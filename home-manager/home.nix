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

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
