{ pkgs ? import <nixpkgs> {}
, zeekCurrent
, zeekTLS
}:

with pkgs;

mkShell {
  buildInputs = [
    zeekCurrent
  ];
}
