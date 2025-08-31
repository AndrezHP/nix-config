{
  description = "Nixos flake!";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    hyprland.url = "github:hyprwm/Hyprland";
    hyprland.inputs.nixpkgs.follows = "nixpkgs";

    emacs-overlay.url = "github:nix-community/emacs-overlay";
    emacs-overlay.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    firefox-addons.url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
    firefox-addons.inputs.nixpkgs.follows = "nixpkgs";

    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    zen-browser.inputs.nixpkgs.follows = "nixpkgs";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    automatic-ripping-machine.url = "github:AndrezHP/automatic-ripping-machine/main?dir=nixos";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      hyprland,
      disko,
      sops-nix,
      automatic-ripping-machine,
      ...
    }@inputs:
    with builtins;
    let
      inherit (self) outputs;
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      hosts = filter (name: pathExists ./hosts/${name}/home.nix) (attrNames (readDir ./hosts));
    in
    {
      nixosConfigurations = {
        desktop = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs system; };
          modules = [
            ./hosts/desktop/configuration.nix
            sops-nix.nixosModules.sops
            automatic-ripping-machine.nixosModules.default
          ];
        };
        laptop = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs system; };
          modules = [
            disko.nixosModules.disko
            ./hosts/laptop/configuration.nix
            sops-nix.nixosModules.sops
          ];
        };
        server = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs system; };
          modules = [
            disko.nixosModules.disko
            ./hosts/server/configuration.nix
            sops-nix.nixosModules.sops
            home-manager.nixosModules.home-manager
          ];
        };
      };

      homeConfigurations = listToAttrs (
        map (name: {
          inherit name;
          value = home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            extraSpecialArgs = { inherit inputs outputs; };
            modules = [ ./hosts/${name}/home.nix ];
          };
        }) hosts
      );

      # nix run nixpkgs#nixos-generators -- --format iso --flake ~/nix-config#initIso -o nixos-init.iso
      nixosConfigurations.initIso = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          (
            { pkgs, modulesPath, ... }:
            {
              imports = [ (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix") ];
              services.openssh.enable = true;
              users.users.root.openssh.authorizedKeys.keys = [
                "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL0Y2pKiFLlDTQ5nEs4sJFfhG03qIQde2PXVpLtyuKcj andreas@nixos"
              ];
              nix.settings.experimental-features = [
                "nix-command"
                "flakes"
              ];
              environment.systemPackages = with pkgs; [
                neovim
                gitMinimal
                curl
              ];
            }
          )
        ];
      };
    };
}
