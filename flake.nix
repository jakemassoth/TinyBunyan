{
  description = "tinyBunyan dev shell";

  inputs = { nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable"; };

  outputs = { self, nixpkgs }:
    let pkgs = nixpkgs.legacyPackages.aarch64-darwin;
    in {
      devShells."aarch64-darwin".default = pkgs.mkShell {
        packages =
          [ pkgs.elixir pkgs.darwin.apple_sdk.frameworks.CoreServices ];
        shellHook = ''
          mkdir -p .nix-mix
          mkdir -p .nix-hex
          mix local.hex --force
          mix local.rebar --force
          mix deps.get
          clang -framework CoreFoundation -framework CoreServices -Wno-deprecated-declarations deps/file_system/c_src/mac/*.c -o priv/mac_listener
          export SHELL=$(which zsh)
          export MIX_HOME=$PWD/.nix-mix
          export HEX_HOME=$PWD/.nix-hex
          export PATH=$PATH:$PWD/priv
          exec $SHELL
        '';
        ERL_AFLAGS = "-kernel shell_history enabled";
      };
    };
}
