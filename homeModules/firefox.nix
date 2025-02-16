{ inputs, ... }: {
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
      extensions = [
        inputs.firefox-addons.packages."x86_64-linux".bitwarden
        inputs.firefox-addons.packages."x86_64-linux".ublock-origin
        inputs.firefox-addons.packages."x86_64-linux".darkreader
        inputs.firefox-addons.packages."x86_64-linux".youtube-shorts-block
        inputs.firefox-addons.packages."x86_64-linux".vimium
        inputs.firefox-addons.packages."x86_64-linux".sponsorblock
        inputs.firefox-addons.packages."x86_64-linux".privacy-badger
        inputs.firefox-addons.packages."x86_64-linux".return-youtube-dislikes
        inputs.firefox-addons.packages."x86_64-linux".facebook-container
        inputs.firefox-addons.packages."x86_64-linux".multi-account-containers
      ];
    };
  };
}
