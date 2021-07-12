{ pkgs ? import <nixpkgs> { } }:

with pkgs;

let
  inherit (lib) optionals;

  basePackages = [ beam.packages.erlangR24.elixir_1_12 elixir_ls git nixfmt ];

  inputs = basePackages ++ optionals stdenv.isLinux inotify-tools
    ++ optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
      # file_system used by phoenix_live_reload
      CoreFoundation
      CoreServices
    ]);

  hooks = ''
    mkdir -p .nix-mix
    mkdir -p .nix-hex
    export MIX_HOME=$PWD/.nix-mix
    export HEX_HOME=$PWD/.nix-hex
    export PATH=$MIX_HOME/bin:$PATH
    export PATH=$HEX_HOME/bin:$PATH
    export LANG=en_US.UTF-8
    export ERL_AFLAGS="-kernel shell_history enabled"
  '';
in mkShell {
  buildInputs = inputs;
  shellHooks = hooks;
}

