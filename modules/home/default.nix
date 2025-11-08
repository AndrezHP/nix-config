{ ... }:
{
  imports = [
    ./applications.nix
    ./btop/btop.nix
    ./git.nix
    ./nvim/nvim.nix
    ./waybar/waybar.nix
    ./zsh.nix
    ./tmux.nix
    ./wlogout/wlogout.nix
    ./firefox.nix
    ./dconf_gnome.nix
    ./emacs.nix
    ./theme.nix
    ./kitty/kitty.nix
  ];
}
