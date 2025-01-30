{pkgs, ...}: {
  gtk = {
    enable = true;
    theme.package = pkgs.adw-gtk3;
    theme.name = "adw-gtk3";
    cursorTheme.package = pkgs.bibata-cursors;
    cursorTheme.name = "Bibata-Modern-Ice";
    iconTheme.package = pkgs.papirus-icon-theme;
    iconTheme.name = "Papirus";
    gtk3.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
      "gtk-selection-background-color" = "rgba(0, 120, 215, 0.5)"; # Semi-transparent blue
    };
    gtk4.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
      "gtk-selection-background-color" = "rgba(0, 120, 215, 0.5)"; # Semi-transparent blue
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk";
    # style.name = "adwaita-dark";
    # style.package = pkgs.adwaita-qt;
  };
}


