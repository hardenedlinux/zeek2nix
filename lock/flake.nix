{
  inputs.flake-compat = {
    url = "github:edolstra/flake-compat";
    flake = false;
  };

  inputs = {
    main.url = "../.";
    nixpkgs.follows = "main/nixpkgs";
  };

  inputs = {
    microvm.url = "github:astro/microvm.nix";
    nixpkgs-hardenedlinux.url = "github:hardenedlinux/nixpkgs-hardenedlinux";
    nixpkgs-hardenedlinux.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {self, ...}: {};
}
