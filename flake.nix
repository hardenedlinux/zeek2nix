{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-lock.follows = "nixpkgs";
    nixos.url = "github:NixOS/nixpkgs/nixos-22.05";
  };

  inputs = {
    cells-lab.url = "github:GTrunSec/cells-lab";
    std.url = "github:divnix/std";
  };

  outputs = {std, ...} @ inputs:
    std.growOn {
      inherit inputs;
      cellsFrom = ./nix;
      cellBlocks = [
        (std.blockTypes.installables "packages")

        (std.blockTypes.functions "devshellProfiles")
        (std.blockTypes.devshells "devshells")

        (std.blockTypes.runnables "entrypoints")

        (std.blockTypes.data "config")

        (std.blockTypes.files "configFiles")

        (std.blockTypes.files "templates")

        (std.blockTypes.functions "library")

        (std.blockTypes.microvms "microvmProfiles")

        (std.blockTypes.functions "overlays")

        (std.blockTypes.nixago "nixago")

        (std.blockTypes.functions "nixosModules")
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
