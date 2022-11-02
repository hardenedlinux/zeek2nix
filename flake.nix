{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixos.url = "github:NixOS/nixpkgs/nixos-22.05";
  };

  inputs = {
    cells-lab.url = "github:GTrunSec/cells-lab";
    std.follows = "cells-lab/std";
  };

  outputs = {std, ...} @ inputs:
    std.growOn {

      inherit inputs;

      cellsFrom = ./nix;

      cellBlocks = with std.blockTypes;[
        (installables "packages")

        (functions "devshellProfiles")
        (devshells "devshells")

        (runnables "entrypoints")

        (data "config")

        (files "configFiles")

        (files "templates")

        (functions "lib")

        (microvms "microvmProfiles")

        (functions "overlays")

        (nixago "nixago")

        (functions "nixosModules")
      ];
    } {
      overlays = (inputs.std.harvest inputs.self ["zeek" "overlays"]).x86_64-linux;
      devShells = inputs.std.harvest inputs.self ["zeek" "devshells"];
      lib = (inputs.std.harvest inputs.self ["zeek" "lib"]).x86_64-linux;
      nixosModules = (inputs.std.harvest inputs.self ["zeek" "nixosModules"]).x86_64-linux;
      packages = inputs.std.harvest inputs.self ["zeek" "packages"];
    };

  nixConfig.extra-trusted-substituters = ["https://zeek.cachix.org"];
  nixConfig.extra-trusted-public-keys = [
    "zeek.cachix.org-1:w590YE/k5sB26LSWvDCI3dccCXipBwyPenhBH2WNDWI="
  ];
}
