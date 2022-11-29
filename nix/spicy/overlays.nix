{
  inputs,
  cell,
}: {
  spicy = final: prev: {
    spicy-parser = prev.callPackage ./packages/spicy.nix {};
  };
}
