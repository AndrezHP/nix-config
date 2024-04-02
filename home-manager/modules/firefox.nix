{ inputs, pkgs, lib, config, ... }:

{
  programs.firefox = {
    enable = true;
    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      EnableTrackingProtection = {
        Value = true;
        Fingerprinting = true;
      };
      HardwareAcceleration = true;
      Permissions.Microphone.BlockNewRequests = true;
      Permissions.Location.BlockNewRequests = true;
      Permissions.Notifications.BlockNewRequests = true;
      Permissions.Camera.BlockNewRequests = true;
    };
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
