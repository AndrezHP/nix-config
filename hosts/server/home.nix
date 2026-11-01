{ ... }:
{
  imports = [
    ../../modules/home
  ];

  homeModules = {
    zsh.enable = true;
    zsh.extraAliases = {
      bs = "sudo nixos-rebuild switch --flake ~/nix-config/#server";
    };
    nvimConfig = {
      enable = true;
      setBuildEnv = true;
      withBuildTools = true;
    };
  };

  home = {
    username = "andreas";
    homeDirectory = "/home/andreas";
    sessionVariables.EDITOR = "nvim";
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "25.05";
}
