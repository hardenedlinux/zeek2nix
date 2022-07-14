{
  inputs,
  cell,
}: {
  default = prev: final: {
    zeek-sources = prev.callPackage ../packages/_sources/generated.nix {};
  };
}
