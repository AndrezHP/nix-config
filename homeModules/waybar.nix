{ lib, ... }: {
  programs.waybar = {
    enable = true;
    systemd = {
      enable = true;
      target = "graphical-session.target";
    };
    style = ../dotfiles/waybar/style.css;
    settings = lib.importJSON ../dotfiles/waybar/config.jsonc;
  };
}
