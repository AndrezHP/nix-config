{ inputs, pkgs, lib, config, ... }:

{
  programs.firefox = {
    enable = true;
    profiles.andreas = {
      # bookmarks = [];
      # settings = {};
      extensions = [
        inputs.firefox-addons.packages."x86_64-linux".bitwarden
        inputs.firefox-addons.packages."x86_64-linux".ublock-origin
        inputs.firefox-addons.packages."x86_64-linux".darkreader
        inputs.firefox-addons.packages."x86_64-linux".tridactyl
        inputs.firefox-addons.packages."x86_64-linux".youtube-shorts-block
      ];
    };
  };
}
