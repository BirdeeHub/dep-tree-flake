{ pkgs ? (
    let
      inherit (builtins) fetchTree fromJSON readFile;
      inherit ((fromJSON (readFile ./flake.lock)).nodes) nixpkgs gomod2nix;
    in
    import (fetchTree nixpkgs.locked) {
      overlays = [
        (import "${fetchTree gomod2nix.locked}/overlay.nix")
      ];
    }
  )
, buildGoApplication ? pkgs.buildGoApplication
, dep-tree-src
, testDeps ? {}
}: let
  depscommands = builtins.mapAttrs (name: value: "mkdir -p /tmp/dep-tree-tests/${name}; cp -r ${value}/* /tmp/dep-tree-tests/${name};") testDeps;
  depscommandsjoined = builtins.concatStringsSep "\n" (builtins.attrValues depscommands);
in
buildGoApplication {
  pname = "dep-tree";
  version = "0.1";
  pwd = "${dep-tree-src}";
  src = "${dep-tree-src}";
  modules = ./gomod2nix.toml;
  preCheck = ''
    ${depscommandsjoined}
  '';
}
