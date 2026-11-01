{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixosModules.ollama;
in
{
  options.nixosModules.ollama.enable = lib.mkEnableOption "Enable Ollama";
  config = lib.mkIf cfg.enable {
    services.ollama = {
      package = pkgs.ollama-rocm; # desktop is AMD
      enable = true;
    };
  };
}
