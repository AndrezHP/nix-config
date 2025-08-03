{ pkgs, ... }:
{
  gamemode = pkgs.writeShellScriptBin "gamemode" ''
    ROUNDING=$(hyprctl getoption decoration:rounding | awk 'NR==1{print $2}')
    if [ "$ROUNDING" -gt 0 ] ; then
        hyprctl --batch "\
            keyword decoration:shadow:enabled 0;\
            keyword decoration:blur:enabled 0;\
            keyword general:gaps_in 0;\
            keyword general:gaps_out 0;\
            keyword general:border_size 1;\
            keyword decoration:rounding 0"
        exit
    fi
    hyprctl reload
  '';

  mountSamba = pkgs.writeShellScriptBin "mountSamba" ''
    read -p "User name: " USERNAME
    read -s -p "Password: " PASSWORD
    sudo mount -t cifs //192.168.8.223/share /mnt/samba_share -o username=$USERNAME,password=$PASSWORD,gid=1000,uid=$USERNAME
  '';

  takeScreenshot = pkgs.writeShellScriptBin "takeScreenshot" ''
    ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" - |\
    ${pkgs.swappy}/bin/swappy -f - -o ~/Media/Screenshots/$(date | awk '{print $1}').png
  '';
}
