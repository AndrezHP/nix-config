{ pkgs, lib, ... }:
pkgs.rustPlatform.buildRustPackage {
  pname = "cargo-pbc";
  version = "5.265.0";
  buildInputs = [
    pkgs.openssl
  ];
  nativeBuildInputs = [
    pkgs.pkg-config
  ];

  # Allow it to build with failed tests since one test fails because of nix file structure
  doCheck = false;

  src = pkgs.fetchFromGitLab {
    owner = "partisiablockchain";
    repo = "language/cargo-partisia-contract";
    rev = "1bb51a58970cdbefda874fdd5fdd4979004d901d";
    hash = "sha256-m8ZEwb/DrW0NxXFsgn3Av+elZEGZnw6tVMuzGguJzgw=";
  };
  cargoHash = "sha256-BF0uQHb1Hq3jJt9E1Cd+RJkaney9ErD8/kEX4VVIftk=";

  meta = {
    description = "Compiles Smart Contracts for the Partisia Blockchain for deployment on-chain.";
    homepage = "https://gitlab.com/partisiablockchain/language/cargo-partisia-contract";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
