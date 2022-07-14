{
  inputs,
  cell,
}: final: prev: {
  zeek-vm-tests = prev.callPackage ./nixos-test.nix {
    inherit inputs cell;
  };
}
