{
  lib,
  inputs,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.homeModules.emacs;
in
{
  options.homeModules.emacs = {
    enable = mkEnableOption "Enable Emacs";
  };

  config = mkIf cfg.enable {
    nixpkgs.overlays = [
      inputs.emacs-overlay.overlays.default
    ];

    nixpkgs.config.permittedInsecurePackages = [ "xpdf-4.05" ];
    home.packages =
      with pkgs;
      [
        binutils # native-comp needs 'as', provided by this
        xpdf
        ## Emacs itself
        ((emacsPackagesFor (emacs-git-pgtk)).emacsWithPackages (
          epkgs: with epkgs; [
            treesit-grammars.with-all-grammars
            vterm
            mu4e
          ]
        ))
        vips # Image processing for preview in Dirvish

        ## Doom dependencies
        git
        ripgrep
        gnutls # for TLS connectivity

        ## Optional dependencies
        fd # faster projectile indexing
        imagemagick # for image-dired
        # (mkIf (config.programs.gnupg.agent.enable)
        #   pinentry-emacs)   # in-emacs gnupg prompts
        zstd # for undo-fu-session/undo-tree compression

        ## Module dependencies
        # :tools direnv
        direnv
        # :email mu4e
        mu
        isync
        # :checkers spell
        (aspellWithDicts (
          ds: with ds; [
            en
            en-computers
            en-science
            da
            es
          ]
        ))
        # :tools editorconfig
        editorconfig-core-c # per-project style config
        # :tools lookup & :lang org +roam
        sqlite
        wordnet
        # :lang cc
        clang-tools
        # :lang latex & :lang org (latex previews)
        # texlive.combined.scheme-medium
        # texlivePackages.wrapfig
        (texlive.combined.scheme-full.withPackages (
          ps: with ps; [
            wrapfig
            capt-of
          ]
        ))
        # :lang beancount
        beancount
        fava
        # :lang nix
        age
        nixfmt-rfc-style # Nix formatter
      ]
      ++ [
        pkgs.nerd-fonts.jetbrains-mono
        pkgs.ubuntu-sans
      ];
  };
}
