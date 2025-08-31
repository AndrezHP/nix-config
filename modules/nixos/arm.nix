{
  config,
  lib,
  ...
}:
let
  cfg = config.nixosModules.arm;
in
{
  options.nixosModules.arm = {
    enable = lib.mkEnableOption "Enable The Automatic-Ripping-Machine";
    user = lib.mkOption {
      default = "arm";
      type = lib.types.str;
      description = "User for file permissions on created directories and ripped files";
    };
    group = lib.mkOption {
      default = "arm";
      type = lib.types.str;
      description = "Group for file permissions on created directories and ripped files";
    };
    targetLocation = lib.mkOption {
      default = "/mnt/tank";
      type = lib.types.str;
      description = "Target output location for the rips";
    };
    languages = {
      audio = lib.mkOption {
        default = [
          "dan"
          "eng"
          "jpn"
          "rus"
        ];
        type = lib.types.listOf lib.types.str;
        description = "Which languages to rip audio for";
      };
      subtitles = lib.mkOption {
        default = [
          "dan"
          "eng"
        ];
        type = lib.types.listOf lib.types.str;
        description = "Which languages to rip subtitles for";
      };
    };
  };

  config =
    let
      audioLanguages = lib.concatStringsSep "," cfg.languages.audio;
      subtitleLanguages = lib.concatStringsSep "," cfg.languages.subtitles;
    in
    lib.mkIf cfg.enable {
      systemd.tmpfiles.rules = [
        "d ${cfg.targetLocation}/raw 0775 ${cfg.user} ${cfg.group} -"
        "d ${cfg.targetLocation}/transcoded 0775 ${cfg.user} ${cfg.group} -"
        "d ${cfg.targetLocation}/completed 0775 ${cfg.user} ${cfg.group} -"
      ];
      services.automatic-ripping-machine = {
        enable = true;
        settings = {
          DISABLE_LOGIN = true;
          AUTO_EJECT = true;
          DATE_FORMAT = "%Y-%m-%d %H:%M:%S";
          RAW_PATH = "${cfg.targetLocation}/raw/";
          TRANSCODE_PATH = "${cfg.targetLocation}/transcoded/";
          COMPLETED_PATH = "${cfg.targetLocation}/completed/";
          LOGLEVEL = "DEBUG";
          # Additional HandBrake arguments for DVDs.
          HB_ARGS_BD = "--subtitle-burned=none --audio-lang-list ${audioLanguages} --subtitle-lang-list ${subtitleLanguages}";
          # Additional Handbrake arguments for Bluray Discs.
          HB_ARGS_DVD = "--subtitle-burned=none --audio-lang-list ${audioLanguages} --subtitle-lang-list ${subtitleLanguages}";
        };
      };
    };
}
