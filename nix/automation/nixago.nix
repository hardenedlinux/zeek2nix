{
  inputs,
  cell,
}: let
  inherit (inputs) std;
in {
  treefmt = std.std.nixago.treefmt {
    configData.formatter.nix = {
      excludes = [
        "generated.nix"
      ];
    };
    configData.formatter.prettier = {
      excludes = [
        "generated.json"
      ];
    };
  };
}
