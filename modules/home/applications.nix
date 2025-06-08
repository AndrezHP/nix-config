{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.homeModules.applications;
in
{
  options.homeModules.applications = {
    cyberTools.enable = mkEnableOption "Enable common cyber security tools";
    cliTools.enable = mkEnableOption "Enable cli tools";
    games.enable = mkEnableOption "Enable games";
  };

  config = {
    home.packages =
      with pkgs;
      [
        tidal-hifi
        spotify
        mpd # Music Player Daemon

        # These might be useful for setting up oauth for mail
        oama # OAuth credential manager
        cyrus-sasl-xoauth2
        yt-dlp

        discord
        pavucontrol
        gnome-calendar
        blueman # Bluetooth manager
        solaar # Manager for Logitech Unifying Receiver
        ncmpcpp # Music player
        porsmo # Cli Pomodoro
        via

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

        musescore
        lilypond-with-fonts # Music in plaintext
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
        (retroarch.withCores (
          cores: with cores; [
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
            citra
          ]
        ))
      ]
      ++ optionals cfg.cliTools.enable [
        ffmpeg
        eza # better ls?
        zoxide # better file path navigation
        tealdeer # tldr command
        jq # like sed, but for JSON
        lazygit
        neofetch
        scc
      ]
      ++ optionals cfg.cyberTools.enable [
        wireshark
        nmap
        netcat
        metasploit
        john
        yersinia
        hashcat
      ];
  };
}
