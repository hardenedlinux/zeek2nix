{
  inputs,
  cell,
}: let
  inherit (inputs.cells-lab.microvms.library) makeVM;
in {
  dev = makeVM {
    channel = inputs.nixos.legacyPackages;
    module = _: {
      imports = [
        cell.nixosModules.zeek
        ./dev.nix
        ./microvm.nix
        # ./dpdk.nix
      ];
      _module.args = {
        inherit (cell) packages;
      };
    };
  };
}
