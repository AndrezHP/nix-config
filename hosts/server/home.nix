{ ... }:
{
  imports = [
    ../../modules/home
  ];

  homeModules = {
    zsh.enable = true;
    zsh.extraAliases = {
      bh = "home-manager switch --flake ~/nix-config/#server";
      bs = "sudo nixos-rebuild switch --flake ~/nix-config/#server";
    };
    nvimConfig.enable = true;
    nvimConfig.setBuildEnv = true;
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
    sessionVariables.EDITOR = "nvim";
  };

  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
