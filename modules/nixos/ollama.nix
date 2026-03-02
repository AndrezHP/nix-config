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
      package = pkgs.ollama-cuda;
      enable = true;
    };
    nixpkgs.config.allowUnfreePredicate =
      pkg:
      builtins.elem (lib.getName pkg) [
        "cuda_cccl"
        "cuda_cudart"
        "cuda_nvcc"
        "libcublas"
        "nvidia-settings"
        "nvidia-x11"
      ];
  };
}
