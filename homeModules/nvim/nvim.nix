{ config, lib, pkgs, ... }:
with lib; let
  cfg = config.programs.neovim.nvimdots;
in
{
  options.programs.neovim.nvimdots = {
    enable = mkEnableOption "Enable nvimdots";
    setBuildEnv = mkEnableOption ''
      Sets environment variables that resolve build dependencies as required by `mason.nvim` and `nvim-treesitter`
      Environment variables are only visible to `nvim` and have no effect on any parent sessions.
      Required for NixOS.
    '';
    withBuildTools = mkEnableOption ''
      Include basic build tools like `gcc` and `pkg-config`.
      Required for NixOS.
    '';
    extraDependentPackages = mkOption {
      type = with types; listOf package;
      default = [ ];
      example = literalExpression "[ pkgs.openssl ]";
      description = "Extra build depends to add `LIBRARY_PATH` and `CPATH`.";
    };
  };
  config =
    let
      build-dependent-pkgs = with pkgs; [
          acl
          attr
          bzip2
          curl
          libsodium
          libssh
          libxml2
          openssl
          stdenv.cc.cc
          systemd
          util-linux
          xz
          zlib
          zstd
          # Packages not included in `nix-ld`'s NixOSModule
          glib
          libcxx
        ]
        ++ cfg.extraDependentPackages;

      makePkgConfigPath = x: makeSearchPathOutput "dev" "lib/pkgconfig" x;
      makeIncludePath = x: makeSearchPathOutput "dev" "include" x;

      nvim-depends-library = pkgs.buildEnv {
        name = "nvim-depends-library";
        paths = map lib.getLib build-dependent-pkgs;
        extraPrefix = "/lib/nvim-depends";
        pathsToLink = [ "/lib" ];
        ignoreCollisions = true;
      };
      nvim-depends-include = pkgs.buildEnv {
        name = "nvim-depends-include";
        paths = splitString ":" (makeIncludePath build-dependent-pkgs);
        extraPrefix = "/lib/nvim-depends/include";
        ignoreCollisions = true;
      };
      nvim-depends-pkgconfig = pkgs.buildEnv {
        name = "nvim-depends-pkgconfig";
        paths = splitString ":" (makePkgConfigPath build-dependent-pkgs);
        extraPrefix = "/lib/nvim-depends/pkgconfig";
        ignoreCollisions = true;
      };
      buildEnv = [
        "CPATH=${config.home.profileDirectory}/lib/nvim-depends/include"
        "CPLUS_INCLUDE_PATH=${config.home.profileDirectory}/lib/nvim-depends/include/c++/v1"
        "LD_LIBRARY_PATH=${config.home.profileDirectory}/lib/nvim-depends/lib"
        "LIBRARY_PATH=${config.home.profileDirectory}/lib/nvim-depends/lib"
        "NIX_LD_LIBRARY_PATH=${config.home.profileDirectory}/lib/nvim-depends/lib"
        "PKG_CONFIG_PATH=${config.home.profileDirectory}/lib/nvim-depends/pkgconfig"
      ];
  in 
  mkIf cfg.enable {
    xdg.configFile = {
      "nvim/init.lua".source = ./init.lua;
      "nvim/lua".source = ./lua;
    };
    home.packages = with pkgs; [
      ripgrep
      black
      stylua
      rust-analyzer
      nil
    ] ++ (with pkgs.vimPlugins; [
      vim-nix # File type and syntax highlighting.
    ]) ++ optionals cfg.setBuildEnv [
      nvim-depends-include
      nvim-depends-library
      nvim-depends-pkgconfig
      patchelf
    ];
    home.extraOutputsToInstall = optional cfg.setBuildEnv "nvim-depends";
    home.shellAliases.nvim = optionalString cfg.setBuildEnv (concatStringsSep " " buildEnv) + " nvim";

    programs.neovim = {
      enable = true;
      withNodeJs = true;
      withPython3 = true;
      extraPackages = with pkgs;
        [
          # Dependent packages used by plugins
          doq
          luarocks
        ]
        ++ optionals cfg.withBuildTools [
          cargo
          clang
          cmake
          gcc
          gnumake
          go
          ninja
          pkg-config
          yarn
        ];

      extraLuaPackages = ls: with ls; [
        luarocks
      ];
    };
  };
}
