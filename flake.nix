{
  description = "Zeek to Nix";

  inputs =  {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "nixpkgs/302ef60620d277fc87a8aa58c5c561b62c925651";
    zeek-plugin-ikev2 = { url = "github:ukncsc/zeek-plugin-ikev2/master"; flake = false;};
    zeek-tls = { url = "https://download.zeek.org/zeek-3.0.10.tar.gz"; flake = false;};
    zeek-current = { url = "https://download.zeek.org/zeek-3.2.1.tar.gz"; flake = false;};
  };


  outputs = inputs: with builtins;
    let
      flakeLock = inputs.nixpkgs.lib.importJSON ./flake.lock;
      loadInput = { locked, ... }:
        builtins.fetchTarball {
          url = locked.url;
          sha256 = locked.narHash;
        };
    in
      (inputs.flake-utils.lib.eachDefaultSystem
        (system:
          let
            pkgs = import inputs.nixpkgs {
              inherit system;
              overlays = [
                (import ./overlay.nix)
              ];
            };
          in
            rec {

              zeekCurrent = pkgs.zeek.overrideAttrs(oldAttrs: {
                version = "3.2.1";
                src = builtins.fetchTarball {
                  url = flakeLock.nodes.zeek-current.locked.url;
                  sha256 = flakeLock.nodes.zeek-current.locked.narHash;
                };
              });

              zeekTLS = pkgs.zeek.overrideAttrs(oldAttrs: {
                version = "3.0.10";
                src = builtins.fetchTarball {
                  url = flakeLock.nodes.zeek-tls.locked.url;
                  sha256 = flakeLock.nodes.zeek-tls.locked.narHash;
                };
              });
              
              packages = inputs.flake-utils.lib.flattenTree {
                inherit zeekCurrent zeekTLS;
              };
              
              devShell = import ./shell.nix { inherit pkgs zeekCurrent zeekTLS;};
              defaultPackage = packages.zeekTLS;
              apps.zeek = flake-utils.lib.mkApp { drv = packages.zeekCurrent; };
            }
        )
      );
}
