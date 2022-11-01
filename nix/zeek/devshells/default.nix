{
  inputs,
  cell,
}: let
  l = nixpkgs.lib // builtins;
  inherit (inputs) nixpkgs std;
in
  l.mapAttrs (_: std.lib.dev.mkShell) {
    default = {lib, ...}: {
      name = "Std: zeek2nix";

      imports = [
        inputs.std.std.devshellProfiles.default
        cell.devshellProfiles.default
      ];
      nixago = [
        inputs.cells._automation.nixago.treefmt
      ];
    };
  }
  // {
    compile = nixpkgs.mkShell {
      buildInputs = [cell.entrypoints.localCompile];
      inputsFrom = [cell.packages.zeek-release];
    };
  }
