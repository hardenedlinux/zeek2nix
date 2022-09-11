{
  inputs,
  cell,
}: let
  l = nixpkgs.lib // builtins;
  inherit (inputs) nixpkgs std;
in
  l.mapAttrs (_: std.std.lib.mkShell) {
    default = {lib, ...}: {
      name = "Std: zeek2nix";

      std.docs.enable = lib.mkForce true;

      imports = [
        inputs.cells-lab.main.devshellProfiles.default
        cell.devshellProfiles.default
      ];
      nixago = [
        inputs.cells.automation.nixago.treefmt
      ];
    };
  }
  // {
    compile = nixpkgs.mkShell {
      buildInputs = [cell.entrypoints.localCompile];
      inputsFrom = [cell.packages.zeek-release];
    };
  }
