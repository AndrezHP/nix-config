{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixosModules.virtualization;
in
{
  options.nixosModules.virtualization = {
    enable = lib.mkEnableOption "Enable virtualization";
    user = lib.mkOption {
      type = lib.types.str;
      description = "User to add to libvirtd group";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.virt-manager.enable = true;
    virtualisation.spiceUSBRedirection.enable = true;
    virtualisation.libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
        ovmf = {
          enable = true;
          packages = [
            (pkgs.OVMF.override {
              secureBoot = true;
              tpmSupport = true;
            }).fd
          ];
        };
      };
    };

    users.users.${cfg.user}.extraGroups = [
      "libvirtd"
    ];
  };
}
