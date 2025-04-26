{
  pkgs,
  config,
  lib,
  ...
}:
{
  options.homeModules.theme.enable = lib.mkEnableOption "Enable theming of gtk/qt";
  config = lib.mkIf config.homeModules.theme.enable {
    home.packages = [ pkgs.arc-theme ];
    dconf.settings."org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
    home.sessionVariables = {
      GTK_THEME = "Arc-Dark";
    };
    gtk = {
      enable = true;
      theme = {
        name = "Arc-Dark";
        package = pkgs.arc-theme;
      };
      cursorTheme = {
        name = "Bibata-Modern-Ice";
        package = pkgs.bibata-cursors;
      };
      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
      };
      gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
      gtk4.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
    };

    qt = {
      enable = true;
      platformTheme.name = "gtk";
      style.name = "catppuccin-qt5ct";
      style.package = pkgs.catppuccin-qt5ct;
    };
  };
}
