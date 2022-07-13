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
    };
  }
