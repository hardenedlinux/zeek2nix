{ pkgs ? import <nixpkgs> {}
, zeekCurrent
, zeekTLS
}:

with pkgs;

mkShell {
  buildInputs = [
    #zeekTLS
    zeekCurrent
  ];
}
