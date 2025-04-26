{ pkgs, config, lib, ... }: 
with lib; let
  cfg = config.homeModules.tmux;
in
{
  options.homeModules.tmux.enable = mkEnableOption "Enable tmux with some configuration";
  config = mkIf cfg.enable {
    programs.tmux = {
      enable = true;
      clock24 = true;
      baseIndex = 1;
      escapeTime = 1500;
      keyMode = "vi";

      plugins = [
        pkgs.tmuxPlugins.vim-tmux-navigator
        pkgs.tmuxPlugins.catppuccin
      ];

      extraConfig = ''
        set -g prefix C-s
        set -g mouse on
        set-option -g status-position top

        set -g @catppuccin_window_left_separator ""
        set -g @catppuccin_window_right_separator " "
        set -g @catppuccin_window_middle_separator " █"
        set -g @catppuccin_window_number_position "right"

        set -g @catppuccin_window_default_fill "number"
        set -g @catppuccin_window_default_text "#W"

        set -g @catppuccin_window_current_fill "number"
        set -g @catppuccin_window_current_text "#W"

        set -g @catppuccin_status_modules_right "directory session"
        set -g @catppuccin_status_left_separator  " "
        set -g @catppuccin_status_right_separator ""
        set -g @catppuccin_status_fill "icon"
        set -g @catppuccin_status_connect_separator "no"

        set -g @catppuccin_directory_text "#{pane_current_path}"

        bind-key h select-pane -L
        bind-key j select-pane -D
        bind-key k select-pane -U
        bind-key l select-pane -R

        bind C-p previous-window
        bind C-n next-window
      '';
    };
  };
}
