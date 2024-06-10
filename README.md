This repo is still in the proof of concept stage. It packages [gabotechs/dep-tree](https://github.com/gabotechs/dep-tree). A more automatic method of creating gomod2nix.toml will be required, and the structure will need to change away from flakes to be submitted to nixpkgs. But for now, it works.

This repo is the result of running nix flake init -t github:nix-community/gomod2nix#app in the directory of the original repo, then running nix develop and then running gomod2nix.

Doing so creates a gomod2nix.toml in the directory of the original repo. The generated files were then moved into their own repo separate from the original source, the original source was imported as a flake input, and extra files were added so that the check phase does not need to try to pull test dependencies from within the sandbox.
