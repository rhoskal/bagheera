{ pkgs ? import <nixpkgs> {} }:

with pkgs;

let
  inherit (lib) optionals;

  basePackages = [
    beam.packages.erlangR24.elixir_1_12
    git
  ];

  inputs = basePackages
    ++ optionals stdenv.isLinux inotify-tools
    ++ optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
      # file_system used by phoenix_live_reload
      CoreFoundation
      CoreServices
    ]);
in
  mkShell {
    buildInputs = inputs;
  }

