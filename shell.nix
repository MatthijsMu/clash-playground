{ pkgs ? import ./nix/nixpkgs.nix {} }:
let
  playground =
    pkgs.haskellPackages.callCabal2nix "clash-playground"
      (pkgs.nix-gitignore.gitignoreSourcePure [./.gitignore] ./.) { };

in playground.env.overrideAttrs (oldEnv: {
  nativeBuildInputs = oldEnv.nativeBuildInputs ++ [
    pkgs.haskellPackages.cabal-install
    pkgs.haskellPackages.stylish-haskell
    pkgs.haskellPackages.haskell-language-server
  ];
})
