{
  inputs,
  cell,
}: let
  inherit (inputs.cells-lab.microvms.library) makeVM;
in {
  dev = makeVM {
    channel = inputs.nixos.legacyPackages;
    module = _: {
      disabledModules = ["services/networking/nomad.nix"];
      imports = [
        cell.nixosModules.zeek
        ./dev.nix
        ./microvm.nix
      ];
      _module.args = {
        inherit (cell) packages;
      };
    };
  };
}
