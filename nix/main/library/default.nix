{
  inputs,
  cell,
}: let
  inherit (inputs) std nixpkgs self;
  inherit (inputs.cells-lab.main.library) callFlake;
  inherit (nixpkgs) lib;

  l = nixpkgs.lib // builtins;

  __inputs__ = callFlake "${(std.incl self [(self + /lock)])}/lock" {
    nixpkgs.locked = inputs.nixpkgs-lock.sourceInfo;
  };
in {
  inherit __inputs__ l;
}
