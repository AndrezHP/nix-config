{ config, pkgs, ... }:
{
  imports = [
    ../../modules/home
  ];

  homeModules = {
    wlogout.enable = true;
    waybar.enable = true;
    zsh.enable = true;
    firefox.enable = true;
    tmux.enable = true;
    theme.enable = true;
    nvimConfig = {
      enable = true;
      setBuildEnv = true;
      withBuildTools = true;
    };
    applications = {
      cliTools.enable = true;
      cyberTools.enable = true;
    };
  };

  nixpkgs = {
    overlays = [ ];
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "andreas";
    homeDirectory = "/home/andreas";
    sessionVariables = {
      EDITOR = "nvim";
    };
  };

  xdg.configFile."hypr".source = ../../dotfiles/hypr;
  xdg.configFile."dunst".source = ../../dotfiles/dunst;
  xdg.configFile."rofi".source = ../../dotfiles/rofi;

  home.packages = with pkgs; [
    alacritty
  ];

  programs.home-manager.enable = true;
  services.syncthing.enable = true;

  xdg = {
    enable = true;
    mimeApps.defaultApplications = {
      "application/pdf" = [ "zathura.desktop" ];
      "image/*" = [ "sxiv.desktop" ];
      "video/png" = [ "mpv.desktop" ];
      "video/jpg" = [ "mpv.desktop" ];
      "video/*" = [ "mpv.desktop" ];
    };
    userDirs = {
      enable = true;
      music = "${config.home.homeDirectory}/Media/Music";
      videos = "${config.home.homeDirectory}/Media/Videos";
      pictures = "${config.home.homeDirectory}/Media/Pictures";
      download = "${config.home.homeDirectory}/Downloads";
      documents = "${config.home.homeDirectory}/Documents";
      desktop = null;
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
