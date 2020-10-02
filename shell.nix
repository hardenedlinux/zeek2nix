{ pkgs ? import <nixpkgs> {}
, zeek
}:

with pkgs;

mkShell {
  buildInputs = [
    zeek
  ];
}
