{
  description = "A basic gomod2nix flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    gomod2nix.url = "github:nix-community/gomod2nix";
    gomod2nix.inputs.nixpkgs.follows = "nixpkgs";
    gomod2nix.inputs.flake-utils.follows = "flake-utils";
    react-stl-viewer = {
      flake = false;
      url = "github:gabotechs/react-stl-viewer/2.2.4";
    };
    react-gcode-viewer = {
      flake = false;
      url = "github:gabotechs/react-gcode-viewer/2.2.4";
    };
    graphql-js = {
      flake = false;
      url = "github:graphql/graphql-js/v17.0.0-alpha.2";
    };
    warp = {
      flake = false;
      url = "github:seanmonstar/warp/v0.3.3";
    };
    dep-tree-src = {
      flake = false;
      url = "github:gabotechs/dep-tree";
    };
  };

  outputs = { self, nixpkgs, flake-utils, gomod2nix, ... }@inputs:
    (flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};

          testDeps = {
            inherit (inputs) react-stl-viewer react-gcode-viewer graphql-js warp;
          };

          # The current default sdk for macOS fails to compile go projects, so we use a newer one for now.
          # This has no effect on other platforms.
          callPackage = pkgs.darwin.apple_sdk_11_0.callPackage or pkgs.callPackage;
        in
        {
          packages.default = callPackage ./. {
            inherit (inputs) dep-tree-src;
            inherit testDeps;
            inherit (gomod2nix.legacyPackages.${system}) buildGoApplication;
          };
          devShells.default = callPackage ./shell.nix {
            inherit (gomod2nix.legacyPackages.${system}) mkGoEnv gomod2nix;
          };
        })
    );
}
