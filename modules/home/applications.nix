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
    basics.enable = mkEnableOption "Enable base packages";
    cyberTools.enable = mkEnableOption "Enable common cyber security tools";
    cliTools.enable = mkEnableOption "Enable cli tools";
    games.enable = mkEnableOption "Enable games";
  };

  config = {
    home.packages =
      with pkgs;
      optionals cfg.basics.enable [
        tidal-hifi
        spotify
        yt-dlp

        # These might be useful for setting up oauth for mail
        oama # OAuth credential manager
        cyrus-sasl-xoauth2

        discord # Chinese spyware
        pavucontrol # Volume
        blueman # Bluetooth manager
        solaar # Manager for Logitech Unifying Receiver
        ncmpcpp # Music player
        porsmo # Cli Pomodoro
        via # QMK layout editor

        qbittorrent
        signal-desktop
        keepassxc # Local password manager
        syncthing # Synchronization between devices
        obs-studio # Recording

        xfce.thunar
        xfce.thunar-volman
        yazi

        brave # Another browser
        calibre # E-book stuff
        zathura # PDF viewer
        qimgv # Image viewer
        wakeonlan # Does what it says

        ani-cli
        libreoffice # MacroFreedom
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
