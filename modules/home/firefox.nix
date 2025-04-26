{
  inputs,
  config,
  lib,
  ...
}:
{
  options.homeModules.firefox.enable = lib.mkEnableOption "Enable firefox with configuration";
  config = lib.mkIf config.homeModules.firefox.enable {
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
        DefaultDownloadDirectory = "\${home}/Downloads";
      };
      profiles.andreas = {
        # bookmarks = [];
        # settings = {};
        extensions.packages = with inputs.firefox-addons.packages."x86_64-linux"; [
          bitwarden
          ublock-origin
          darkreader
          youtube-shorts-block
          vimium
          sponsorblock
          privacy-badger
          return-youtube-dislikes
          facebook-container
          multi-account-containers
        ];
      };
    };
  };
}
