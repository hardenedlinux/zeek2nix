{ pkgs ? import <nixpkgs> {}}:

with pkgs;

mkShell {
  buildInputs = [
    zeekTLS
    #zeekCurrent
  ];
}
