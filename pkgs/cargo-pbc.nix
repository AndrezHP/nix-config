{ pkgs, lib, ... }:
pkgs.rustPlatform.buildRustPackage {
  pname = "cargo-pbc";
  version = "5.191.0";
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
    rev = "4d2568850dd86d2afd71d628be06df73d6d43430";
    hash = "sha256-ZJ6+GLwNmSo7P5RhPSCtmpnLPf6zm9h3gMyMEYtgki0=";
  };
  cargoHash = "sha256-GGQ+1x/NaPfU3M+4FHxPg87+XUeLleLk8+2Rc1wzwCE=";
  meta = {
    description = "Compiles Smart Contracts for the Partisia Blockchain for deployment on-chain.";
    homepage = "https://gitlab.com/partisiablockchain/language/cargo-partisia-contract";
    license = lib.licenses.mit;
    mainProgram = "cargo-pbc";
  };
}
