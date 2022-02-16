{
  description = "Vast Cells development shell";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  inputs.devshell.url = "github:numtide/devshell";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.cells.url = "github:GTrunSec/DevSecOps-cells";
  outputs = inputs:
    inputs.flake-utils.lib.eachSystem [ "x86_64-linux" ] (
      system: let
        cellsProfiles = inputs.cells.devshellProfiles.${system};
        devshell = inputs.devshell.legacyPackages.${system};
        nixpkgs = inputs.nixpkgs.legacyPackages.${system};
      in
        {
          devShell = devshell.mkShell {
            name = "zeek2nix";
            imports = [
              cellsProfiles.common
              (devshell.importTOML ../misc/spicy.toml)
            ];
            commands = [
              {
                name = "cachix-push";
                help = "push zeek-master binary cachix to cachix";
                command = ''
                  nix -Lv build .\#zeek-release --no-link --json | jq -r '.[].outputs | to_entries[].value' | cachix push zeek
                  nix -Lv build .\#zeek-microvm --no-link --json | jq -r '.[].outputs | to_entries[].value' | cachix push zeek
                '';
              }
              {
                name = "spicy-plugin-btest";
                help = "Test";
                command = "btest -d -j -a installation && btest -d -j";
              }
            ];
            packages = [  ];
            devshell.startup.nodejs-setuphook = nixpkgs.lib.stringsWithDeps.noDepEntry ''
            '';
          };
        }
    );
}