{
  description = "Zeek to Nix";
  # nixConfig = {
  #   substituters = [
  #     "http://221.4.35.244:8301/"
  #   ];
  #   trusted-public-keys = [
  #     "221.4.35.244:3ehdeUIC5gWzY+I7iF3lrpmxOMyEZQbZlcjOmlOVpeo="
  #   ];
  # };

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "nixpkgs";

    zeek-tls = { url = "https://download.zeek.org/zeek-4.0.0.tar.gz"; flake = false; };
    zeek-rc = { url = "https://download.zeek.org/zeek-4.0.0-rc2.tar.gz"; flake = false; };

    zeek-plugin-pdf = { url = "git+https://github.com/reservoirlabs/zeek-pdf-analyzer"; flake = false; }; #failure to 3.0.1
    zeek-plugin-zip = { url = "git+https://github.com/reservoirlabs/zeek-zip-analyzer"; flake = false; }; #failure to 3.0.1
    zeek-plugin-ikev2 = { url = "git+https://github.com/ukncsc/zeek-plugin-ikev2"; flake = false; }; #failure to 3.2.1
    zeek-plugin-postgresql = { url = "git+https://github.com/0xxon/zeek-postgresql"; flake = false; };
    zeek-plugin-http2 = { url = "git+https://github.com/MITRECND/bro-http2/"; flake = false; };
    zeek-plugin-community-id = { url = "git+https://github.com/corelight/zeek-community-id/"; flake = false; };
    icsnpp-bacnet = { url = "git+https://github.com/cisagov/icsnpp-bacnet"; flake = false; };
    metron-zeek-plugin-kafka = { url = "git+https://github.com/apache/metron-bro-plugin-kafka/"; flake = false; };
  };

  outputs = inputs: with builtins;
    {
      overlay = final: prev: {
        zeek = prev.callPackage ./nix {
          KafkaPlugin = true;
          PostgresqlPlugin = true;
          Http2Plugin = true;
          Ikev2Plugin = true;
          CommunityIdPlugin = true;
          ZipPlugin = true;
          PdfPlugin = true;
          SpicyPlugin = true;
        };
        zeek-rc = (final.zeek.override ({
          version = "4.0.0-rc2";
        })).overrideAttrs (old: rec {
          src = inputs.zeek-rc;
        });
        zeekTLS = (final.zeek.override ({
          version = "4.0.0";
        })).overrideAttrs (old: rec {
          src = inputs.zeek-tls;
        });
      };
    } //
    (inputs.flake-utils.lib.eachSystem [ "x86_64-linux" "x86_64-darwin" ]
      (system:
        let
          pkgs = import inputs.nixpkgs {
            inherit system;
            overlays = [
              inputs.self.overlay
            ];
            config = {
              allowUnsupportedSystem = true;
            };
          };
        in
        rec {
          packages = inputs.flake-utils.lib.flattenTree rec {
            zeekTLS = pkgs.zeekTLS;
            zeek-rc = pkgs.zeek-rc;
          };

          hydraJobs = {
            inherit packages;
          };

          devShell = with pkgs; mkShell {
            buildInputs = [ pkgs.zeekTLS ];
          };
          #
          apps = {
            zeekTLS = inputs.flake-utils.lib.mkApp { drv = packages.zeekTLS; exePath = "/bin/zeekctl"; };
            zeek-rc = inputs.flake-utils.lib.mkApp { drv = packages.zeek-rc; exePath = "/bin/zeekctl"; };
          };

          defaultPackage = packages.zeekTLS;
          defaultApp = apps.zeekTLS;
        }
      ) // {
      nixosModules = { zeek = import ./module; };
    }
    );
}
