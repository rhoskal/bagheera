let
  sources = import ./nix/sources.nix { };
  pkgs = import sources.nixpkgs { };

  inherit (pkgs.lib) optionals;

  basePackages = [ pkgs.elixir pkgs.git pkgs.nixfmt ];

  inputs = basePackages ++ optionals pkgs.stdenv.isLinux pkgs.inotify-tools
    ++ optionals pkgs.stdenv.isDarwin (with pkgs.darwin.apple_sdk.frameworks; [
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
in pkgs.mkShell {
  buildInputs = inputs;
  shellHooks = hooks;
}
