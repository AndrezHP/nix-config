{
  pkgs,
  config,
  lib,
  ...
}:
{
  options.homeModules.theme.enable = lib.mkEnableOption "Enable theming of gtk/qt";
  config = lib.mkIf config.homeModules.theme.enable {
    home.packages = [ pkgs.catppuccin-gtk ];
    home.sessionVariables.GTK_THEME = "Arc-Dark";
    gtk = {
      enable = true;
      theme = {
        name = "Adwaita-dark";
        package = pkgs.gnome-themes-extra;
      };
      cursorTheme = {
        name = "Bibata-Modern-Ice";
        package = pkgs.bibata-cursors;
      };
      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
      };
      gtk4.theme = config.gtk.theme;
    };
    qt = {
      enable = true;
      platformTheme.name = "gtk3";
      style.name = "catppuccin-qt5ct";
      style.package = pkgs.catppuccin-qt5ct;
    };
  };
}
