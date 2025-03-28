{pkgs, config, lib, ...}:
with lib;
let
  cfg = config.homeModules.applications;
in 
{
  options.homeModules.applications = {
    games.enable = mkEnableOption "Enable games";
    games.modernEmulation = {
      enable = mkEnableOption "Enable emulators for modern consoles";
    };
    cliTools.enable = mkEnableOption "Enable cli tools";
    cyberTools.enable = mkEnableOption "Enable common cyber security tools";
    devTools.enable = mkEnableOption "Enable development tools";
  };

  config = {
    home.packages = with pkgs; [
      ani-cli
      spicetify-cli 
      spotify
      mpd # Music Player Daemon
      ncspot # ncurses spotify

      webcord
      obsidian
      pavucontrol
      gnome-calendar
      blueman
      solaar # Manager for Logitech Unifying Receiver
      ncmpcpp # Music player
      ventoy # Create bootable USB drives
      porsmo # Cli Pomodoro

      qbittorrent
      signal-desktop
      keepassxc
      syncthing # Synchronization between devices
      obs-studio

      xfce.thunar
      xfce.thunar-volman
      lf
      yazi

      brave # Another browser

      calibre # E-book software
      
      zathura # PDF viewer
      sxiv # Image viewer

      libreoffice

      # Virtualization 
      qemu
      virt-manager
      wine

      musescore
      # reaper # Digital audio workstation
      # kodi-wayland
      # mattermost # Slack alternative

      meson
    ] 
    ++ optionals cfg.games.enable [
      wine
      steam
      steam-run
      runelite
      lutris-unwrapped
      bottles-unwrapped
      heroic-unwrapped
      retroarch-full
    ] 
    ++ optionals cfg.games.modernEmulation.enable [
      cemu
      suyu
      ryujinx
    ] 
    ++ optionals cfg.cliTools.enable [
      # Experimental
      eza # better ls?
      zoxide # better file path navigation
      tealdeer # tldr command
      jq # like sed, but for JSON
      lazygit
      neofetch
    ] 
    ++ optionals cfg.cyberTools.enable [
      wireshark
      nmap
      netcat
      metasploit
      john
      yersinia
      hashcat
    ]
    ++ optionals cfg.devTools.enable [
      jetbrains-toolbox

      # Container alternative to docker
      podman
      podman-compose
      podman-desktop
      podman-tui

      # PostgreSQL platform
      pgadmin4
    ];
  };
}
