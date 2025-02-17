{pkgs, config, lib, ...}: 
with lib; let
  cfg = config.homeModules.theme;
in
{
  options.homeModules.theme.enable = mkEnableOption "Enable theming of gtk/qt";
  config = mkIf cfg.enable {
    dconf.settings."org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
    gtk = {
      enable = true;
      theme = {
        name = "Adwaita-dark";
        package = pkgs.gnome-themes-extra;
      };
      cursorTheme.package = pkgs.bibata-cursors;
      cursorTheme.name = "Bibata-Modern-Ice";
      iconTheme.package = pkgs.papirus-icon-theme;
      iconTheme.name = "Papirus-Dark";
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
      style.name = "adwaita-dark";
      style.package = pkgs.adwaita-qt;
    };
  };
}


