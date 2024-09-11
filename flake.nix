{
  description = "tinyBunyan dev shell";

  inputs = { nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable"; };

  outputs = { self, nixpkgs }:
    let pkgs = nixpkgs.legacyPackages.aarch64-darwin;
    in {
      devShells."aarch64-darwin".default = pkgs.mkShell {
        packages = [ pkgs.elixir ];
        shellHook = ''
          mix local.hex
          mix archive.install hex phx_new
          export SHELL=$(which zsh)
          exec $SHELL
        '';

      };
    };
}
