{ inputs, pkgs, lib, config, ... }:
{
  programs.git = { 
    enable = true;
    userName = "andreas";
    userEmail = "usermail@mail.com";
    extraConfig = {
      init.defaultBranch = "main";
    };
  };
}
