{pkgs, config, lib, ...}: 
with lib; let
  cfg = config.homeModules.theme;
in
{
  options.homeModules.theme.enable = mkEnableOption "Enable theming of gtk/qt";
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      gnome-themes-extra
      catppuccin-gtk
      dracula-theme
      nwg-look
      nordic
      tokyonight-gtk-theme
    ];
    dconf.settings."org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
    home.sessionVariables = {
      GTK_THEME = "Nordic-darker";
    };
    gtk = {
      enable = true;
      theme = {
        name = "nordic-darker"; # Adjust variant as needed
        package = pkgs.nordic;
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
      style.name = "catppuccin-qt5ct";
      style.package = pkgs.catppuccin-qt5ct;
    };
  };
}


