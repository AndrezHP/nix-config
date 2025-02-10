{pkgs, config, lib, ...}:
with lib;
let
  cfg = config.packs;
in 
{
  options.packs = {
    games.enable = mkEnableOption "Enable games";
    games.modernEmulation = {
      enable = mkEnableOption "Enable emulator for modern consoles";
    };
    cliTools.enable = mkEnableOption "Enable cli tools";
    cyberTools.enable = mkEnableOption "Enable common cyber security tools";
    devTools.enable = mkEnableOption "Enable development tools";
  };

  config = {
    home.packages = with pkgs; [
      spicetify-cli # spotify
      webcord
      obsidian
      emacs

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
      dolphin # File manager
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
      # newsflash # RSS reader
      # mattermost # Slack alternative
    ] ++ optionals cfg.games.enable [
      wine
      steam
      steam-run
      runelite
      lutris-unwrapped
      bottles-unwrapped
      heroic-unwrapped
      retroarch-full
    ] ++ optionals cfg.games.modernEmulation.enable [
      cemu
      suyu
      ryujinx
    ] ++ optionals cfg.cliTools.enable [
      # Experimental
      eza
      zoxide
      tealdeer
      ani-cli
      jq
      lazygit
      neofetch
    ] ++ optionals cfg.cyberTools.enable [
      wireshark
      nmap
      netcat
      metasploit
      john
      yersinia
      hashcat
    ] ++ optionals cfg.devTools.enable [
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
