{ pkgs }:

let
  imgLink = "https://gruvbox-wallpapers.pages.dev/wallpapers/anime/ghibli-japanese-walled-garden.png";

  image = pkgs.fetchurl {
    url = imgLink;
    sha256 = "00qklzkj6viv01a4nxjvc8sl5j2mvr0ggkhgkwk6si3ljpdyyhnp"; 
  };
in
pkgs.stdenv.mkDerivation {
  name = "sddm-theme";
  src = pkgs.fetchFromGitHub {
    owner = "AndrezHP";
    repo = "sddm-sugar-dark";
    rev = "7361e59a100048ef5e38c4a6c9d8e695a2de50c7";
    sha256 = "0g156y34frr8qpr2dqlzx19nilv78fc22nbafcjkr242rgdj8lwc";
  };
  installPhase = ''
    mkdir -p $out
    cp -R ./* $out/
    cd $out/
    rm Background.jpg
    cp -r ${image} $out/Background.jpg
   '';
}

