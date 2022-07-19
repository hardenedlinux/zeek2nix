{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixos.url = "github:NixOS/nixpkgs/nixos-22.05";
  };

  inputs = {
    cells-lab.url = "github:GTrunSec/cells-lab";
    std.url = "github:divnix/std";
    data-merge.follows = "cells-lab/data-merge";
    yants.follows = "std/yants";
    std.inputs.kroki-preprocessor.follows = "cells-lab/kroki-preprocessor";
  };

  outputs = {std, ...} @ inputs:
    std.growOn {
      inherit inputs;
      cellsFrom = ./cells;
      organelles = [
        (std.installables "packages")

        (std.functions "devshellProfiles")
        (std.devshells "devshells")

        (std.runnables "entrypoints")

        (std.data "config")

        (std.files "configFiles")

        (std.files "templates")

        (std.functions "library")

        (std.microvms "microvmProfiles")

        (std.functions "overlays")

        (std.functions "nixosModules")
      ];
    } {
      overlays = inputs.std.deSystemize "x86_64-linux" (inputs.std.harvest inputs.self ["zeek" "overlays"]);
      devShells = inputs.std.harvest inputs.self ["zeek" "devshells"];
      lib = inputs.std.harvest inputs.self ["zeek" "library"];
      nixosModules = inputs.std.deSystemize "x86_64-linux" (inputs.std.harvest inputs.self ["zeek" "nixosModules"]);
      packages = inputs.std.harvest inputs.self ["zeek" "packages"];
    };

  nixConfig.extra-trusted-substituters = ["https://zeek.cachix.org"];
  nixConfig.extra-trusted-public-keys = [
    "zeek.cachix.org-1:w590YE/k5sB26LSWvDCI3dccCXipBwyPenhBH2WNDWI="
  ];
}
