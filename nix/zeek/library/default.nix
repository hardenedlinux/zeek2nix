{
  inputs,
  cell,
}: let
  nixpkgs = inputs.nixpkgs.appendOverlays [
    cell.overlays.default
    cell.overlays.nixos-test
    cell.overlays.static
  ];
in {
  inherit nixpkgs;
  inherit (nixpkgs) zeekWithPlugins zeekPluginCi;
}
