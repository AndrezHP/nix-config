{ ... }:
{
  imports = [
    ./kanata/kanata.nix
    ./ollama.nix
    ./virtualization.nix
    ./desktops
    ./arm.nix
  ];
}
