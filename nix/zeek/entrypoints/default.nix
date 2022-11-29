{
  inputs,
  cell,
}: let
  inherit (inputs.cells-lab.writers.lib) writeShellApplication;
in {
  spicyCheck = writeShellApplication {
    name = "spicyCheck";
    runtimeInputs = [cell.packages.zeek-release];
    text = ''
      cd "$PRJ_ROOT"/nix/zeek/overlays/nixos/scripts
      zeek -NN Zeek::Spicy
      spicyz -D zeek my-http.spicy my-http.evt -o my-http.hlto
    '';
  };
  localCompile = writeShellApplication {
    name = "localCompile";
    runtimeInputs = [];
    text = ''
      ./configure --prefix="$*"
    '';
  };
}
