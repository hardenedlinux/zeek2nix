{
  inputs,
  cell,
}: {
  nixpkgs = inputs.nixpkgs.appendOverlays [
    cell.overlays.default
    cell.overlays.nixos-test
  ];
}
