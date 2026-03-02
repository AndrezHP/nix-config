{ pkgs, ... }:
{
  gamemode = pkgs.writeShellScriptBin "gamemode" ''
    GAP=$(hyprctl getoption general:gaps_in | awk 'NR==1{print $3}')
    if [[ "$GAP" -gt 0 ]] ; then
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
    sudo mount -t cifs //192.168.8.223/public /mnt/samba_share -o username=$USERNAME,password=$PASSWORD,gid=1000,uid=$USERNAME
  '';

  takeScreenshot = pkgs.writeShellScriptBin "takeScreenshot" ''
    ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" - |\
    ${pkgs.swappy}/bin/swappy -f - -o ~/Media/Screenshots/$(date | awk '{print $1}').png
  '';

  nixSearch = pkgs.writeShellScriptBin "ns" ''
    if [ ! -d ~/repos ]; then
       mkdir ~/repos
    fi
    if [ ! -d ~/repos/nixpkgs ]; then
      echo "Cloning nixpkgs to be able to search, this may take a while..."
      git clone https://github.com/NixOS/nixpkgs.git ~/repos/nixpkgs
    fi
    find ~/repos/nixpkgs/pkgs -type f | grep '\.nix' | nvim $(fzf --with-nth=-2.. --delimiter="/" --preview="bat --color=always {}")
  '';
  qrCopy = pkgs.writeShellScriptBin "qrCopy" ''
    spectacle -bm -o ~/Downloads/QR.png & zbarimg -q --raw ~/Downloads/QR.png | wl-copy
  '';
  nixClean = pkgs.writeShellScriptBin "nix-clean" ''
    set -euo pipefail

    KEEP=3
    OPTIMIZE=false
    for arg in "$@"; do
    case "$arg" in
        --optimize) OPTIMIZE=true ;;
        *) echo "Unknown argument: $arg" >&2; exit 1 ;;
    esac
    done

    if [[ $EUID -ne 0 ]]; then
    echo "Error: this script must be run with sudo for system generation cleanup." >&2
    exit 1
    fi

    echo "=== Nix Cleanup ==="

    echo "[1/4] Cleaning system generations (keeping last $KEEP)..."
    sudo nix-env --profile /nix/var/nix/profiles/system --delete-generations +$KEEP

    echo "[2/4] Cleaning user generations (keeping last $KEEP)..."
    nix-env --delete-generations +$KEEP

    echo "[3/4] Cleaning home-manager generations (keeping last $KEEP)..."
    if [ -e /nix/var/nix/profiles/per-user/$USER/home-manager ]; then
    nix-env --profile /nix/var/nix/profiles/per-user/$USER/home-manager --delete-generations +$KEEP
    fi

    echo "[4/4] Running garbage collection..."
    sudo nix-collect-garbage -d

    if [[ "$OPTIMIZE" == true ]]; then
    echo "[+] Optimising nix store (hard-linking duplicate files)..."
    nix store optimise
    fi

    echo "=== Done ==="
  '';
}
