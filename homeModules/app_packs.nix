{pkgs, config, lib, ...}:
with lib;
let
  cfg = config.packs;
in 
{
  options.packs = {
    games.enable = mkEnableOption "Enable games";
    cliTools.enable = mkEnableOption "Enable cli tools";
    cyberTools.enable = mkEnableOption "Enable common cyber security tools";
  };

  config = {
    home.packages = with pkgs; [
      spotify
      webcord
      obsidian

      qbittorrent
      signal-desktop
      keepassxc
      syncthing # Synchronization between devices
      obs-studio

      xfce.thunar
      xfce.thunar-volman
      lf

      brave # Another browser

      calibre # E-book software
      dolphin # File manager
      zathura # PDF viewer
      sxiv # Image viewer

      # Virtualization 
      qemu
      virt-manager
      wine

      jetbrains-toolbox
      musescore
      # reaper # Digital audio workstation
      # kodi-wayland
      # newsflash # RSS reader
    ] ++ optionals cfg.games.enable [
      wine
      steam
      steam-run
      runelite
      lutris-unwrapped
      bottles-unwrapped
      heroic-unwrapped
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
    ];
  };
}
