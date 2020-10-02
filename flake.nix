{
  description = "Zeek to Nix";

  inputs =  {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "nixpkgs/302ef60620d277fc87a8aa58c5c561b62c925651";
  };
  outputs = { self, nixpkgs, flake-utils }:
    (flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [
            ];
          };
        in
        rec {
          packages = flake-utils.lib.flattenTree {
            zeek = pkgs.callPackage ./. {};
          };
            devShell = import ./shell.nix { inherit pkgs; zeek = packages.zeek;};
            defaultPackage = packages.zeek;
            apps.hello = flake-utils.lib.mkApp { drv = packages.zeek; };
          }
      )
    );
}
