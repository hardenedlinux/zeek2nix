{
  description = "Zeek to Nix";

  inputs =  {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "nixpkgs/302ef60620d277fc87a8aa58c5c561b62c925651";

    zeek-tls = { url = "https://download.zeek.org/zeek-3.0.11.tar.gz"; flake = false;};
    zeek-current = { url = "https://download.zeek.org/zeek-3.2.2.tar.gz"; flake = false;};

    zeek-plugin-pdf = { url = "git+https://github.com/reservoirlabs/zeek-pdf-analyzer"; flake = false;}; #failure to 3.0.1
    zeek-plugin-zip = { url = "git+https://github.com/reservoirlabs/zeek-zip-analyzer"; flake = false;}; #failure to 3.0.1
    zeek-plugin-ikev2 = { url = "git+https://github.com/ukncsc/zeek-plugin-ikev2"; flake = false;}; #failure to 3.2.1
    zeek-plugin-postgresql  = { url = "git+https://github.com/0xxon/zeek-postgresql"; flake = false;};
    zeek-plugin-http2 = { url = "git+https://github.com/MITRECND/bro-http2/"; flake = false;};
    zeek-plugin-community-id = { url = "git+https://github.com/corelight/zeek-community-id/"; flake = false;};

    metron-zeek-plugin-kafka  = { url = "git+https://github.com/apache/metron-bro-plugin-kafka/"; flake = false;};
  };

  outputs = inputs: with builtins;
    (inputs.flake-utils.lib.eachDefaultSystem
      (system:
        let
          overlay = final: prev: {
            zeek = outputs.self.packages.zeekCurrent;
            zeekTLS = outputs.self.packages.zeekTLS;
          };
          pkgs = import inputs.nixpkgs {
            inherit system;
            overlays = [
              (import ./overlay.nix)
            ];
          };
        in
          rec {

            zeekCurrent = (pkgs.zeek.override({
              version = "3.2.2";
            })).overrideAttrs(old: rec {
              src = inputs.zeek-current;
            });

            zeekTLS = (pkgs.zeek.override({
              version = "3.0.11";
            })).overrideAttrs(old: rec {
              src = inputs.zeek-tls;
            });


            packages = inputs.flake-utils.lib.flattenTree {
              inherit zeekCurrent zeekTLS;
            };

            devShell = import ./shell.nix { inherit pkgs zeekCurrent zeekTLS;};
            #
            apps = {
              zeekTLS = inputs.flake-utils.lib.mkApp { drv = packages.zeekTLS; exePath = "/bin/zeekctl"; };
              zeekCurrent = inputs.flake-utils.lib.mkApp { drv = packages.zeekCurrent; exePath = "/bin/zeekctl";};
            };

            defaultPackage = packages.zeekCurrent;
            defaultApp = apps.zeekCurrent;
          }
      ) // {
        nixosModule = import ./module;
      }
    );
}
