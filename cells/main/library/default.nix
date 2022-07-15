{
  inputs,
  cell,
}: let
  inherit (inputs) std nixpkgs self;
in {
  __inputs__ =
    (std.deSystemize nixpkgs.system
      (import "${(std.incl self [(self + /lock)])}/lock").inputs)
    // inputs;
}
