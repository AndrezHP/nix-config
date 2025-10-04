{ pkgs, ... }:
pkgs.rustPlatform.buildRustPackage rec {
  pname = "cargo-partisia-contract";
  version = "5.328.0";

  buildInputs = [
    pkgs.openssl
  ];

  nativeBuildInputs = [
    pkgs.pkg-config
  ];

  doCheck = false;

  src = pkgs.fetchCrate {
    inherit pname version;
    sha256 = "sha256-gfBeG1XS//X+/imsDjnUVld31GLJK86dIYmGwx/je4c=";
  };

  cargoHash = "sha256-oUy/f5GO0MWo8toyfz/UGZfcpoKY+CT5Wg3jifIyXOg=";
}
