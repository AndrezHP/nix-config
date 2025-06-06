{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.nixosModules.kanata;
in
{
  options.nixosModules.kanata.enable = mkEnableOption "Enable kanata";
  config = mkIf cfg.enable {
    # Enable the uinput module
    boot.kernelModules = [ "uinput" ];

    # Enable uinput
    hardware.uinput.enable = true;

    # Set up udev rules for uinput
    services.udev.extraRules = ''
      KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"
    '';

    # Ensure the uinput group exists and that the service is in it
    users.groups.uinput = {
      members = [ "kanata-default.service" ];
    };

    # Add the Kanata service user to necessary groups
    systemd.services.kanata-internalKeyboard.serviceConfig = {
      SupplementaryGroups = [
        "input"
        "uinput"
      ];
    };

    services.kanata = {
      enable = true;
      package = pkgs.kanata;
      keyboards.default.devices = [ ];
      keyboards.default.config = builtins.readFile ./config.kbd;
    };
    services.udev = {
      packages = [ pkgs.kanata ];
    };
  };
}
