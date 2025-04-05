{ lib, config, ... }:
with lib; let
  cfg = config.nixosModules.kanata;
in
{
  options.nixosModules.kanata = {
    enable = mkEnableOption "Enable kanata";
  };

  config = mkIf cfg.enable {
    # Enable the uinput module
    boot.kernelModules = [ "uinput" ];

    # Enable uinput
    hardware.uinput.enable = true;

    # Set up udev rules for uinput
    services.udev.extraRules = ''
      KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"
    '';

    # Ensure the uinput group exists
    users.groups.uinput = { };

    # Add the Kanata service user to necessary groups
    systemd.services.kanata-internalKeyboard.serviceConfig = {
      SupplementaryGroups = [
        "input"
        "uinput"
      ];
    };

    services.kanata = {
      enable = true;
      extraDefCfg = "process-unmapped-keys yes";
      config = builtins.readFile ./config.kbd;
    };
  };
}
