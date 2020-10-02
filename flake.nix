{
  description = "Zeek to Nix";

  inputs =  {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "nixpkgs/302ef60620d277fc87a8aa58c5c561b62c925651";

    zeek-tls = { url = "https://download.zeek.org/zeek-3.0.10.tar.gz"; flake = false;};
    zeek-current = { url = "https://download.zeek.org/zeek-3.2.1.tar.gz"; flake = false;};


    zeek-plugin-ikev2 = { url = "github:ukncsc/zeek-plugin-ikev2/master"; flake = false;};
    zeek-postgresql  = { url = "github:0xxon/zeek-postgresql/master"; flake = false;};
    metron-bro-plugin-kafka  = { url = "github:apache/metron-bro-plugin-kafka/master"; flake = false;};
    bro-http2 = { url = "github:MITRECND/bro-http2/master"; flake = false;};

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
                src = loadInput flakeLock.nodes.zeek-current;
              });

              zeekTLS = pkgs.zeek.overrideAttrs(oldAttrs: {
                version = "3.0.10";
                src = loadInput flakeLock.nodes.zeek-tls;
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
