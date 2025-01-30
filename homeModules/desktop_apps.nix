{pkgs, ...}: {
  home.packages = with pkgs; [
    spotify
    obsidian # Notes
    qbittorrent
    signal-desktop
    keepassxc
    discord
    syncthing # Synchronization between devices
    obs-studio

    xfce.thunar
    xfce.thunar-volman
    lf

    brave # Another browser

    calibre # E-book software
    dolphin # File manager
    brave
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
  ];

}
