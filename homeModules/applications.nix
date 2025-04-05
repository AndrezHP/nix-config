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
      spicetify-cli
      spotify
      mpd # Music Player Daemon
      ncspot # ncurses spotify

      discord
      obsidian
      pavucontrol
      gnome-calendar
      blueman # Bluetooth manager
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

      ani-cli
      libreoffice
      gimp # Gnu image manipulation program
      krita # Foss painting program

      # Virtualization 
      qemu
      virt-manager
      wine

      musescore
      # reaper # Digital audio workstation
      # kodi-wayland
      # mattermost # Slack alternative

      meson # Build something
    ] 
    ++ optionals cfg.games.enable [
      wine
      steam
      steam-run
      runelite
      lutris-unwrapped
      bottles-unwrapped
      heroic-unwrapped
      (retroarch.withCores (cores: with cores; [
          mame2003-plus # All-around arcade emulation
          puae # Commodore Amiga
          dosbox-pure # DOS
          gambatte # GB/GBC
          mgba # GBA
          beetle-vb # Virtual boy
          melonds # Nintendo DS
          quicknes # NES
          snes9x # SNES
          mupen64plus # N64
          genesis-plus-gx # Sega Genesis
          picodrive # Sega MegaDrive/MegaCD/32X emulator
          beetle-saturn # Sega Saturn
          flycast # Sega Dreamcast
          fbalpha2012 # Neo Geo
          pcsx-rearmed # PSX
          swanstation # PSX (Port of duckstation)
          pcsx2 # PS2
          dolphin # Wii / GameCube
      ]))
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
