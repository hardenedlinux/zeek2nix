{
  description = "Zeek to Nix";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "nixpkgs/dc68bad367deb8ad1aec9632fef4381c4c8da39a";
    flake-compat = { url = "github:edolstra/flake-compat"; flake = false; };

    zeek-tls = { url = "https://download.zeek.org/zeek-4.0.1.tar.gz"; flake = false; };
    zeek-rc = { url = "https://download.zeek.org/zeek-4.0.0.tar.gz"; flake = false; };

    zeek-plugin-pdf = { url = "git+https://github.com/reservoirlabs/zeek-pdf-analyzer"; flake = false; }; #failure to 3.0.1
    zeek-plugin-zip = { url = "git+https://github.com/reservoirlabs/zeek-zip-analyzer"; flake = false; }; #failure to 3.0.1
    zeek-plugin-ikev2 = { url = "git+https://github.com/ukncsc/zeek-plugin-ikev2"; flake = false; }; #failure to 3.2.1
    zeek-plugin-postgresql = { url = "git+https://github.com/0xxon/zeek-postgresql?ref=main"; flake = false; };
    zeek-plugin-http2 = { url = "git+https://github.com/MITRECND/bro-http2/"; flake = false; };
    zeek-plugin-community-id = { url = "git+https://github.com/corelight/zeek-community-id/?ref=master"; flake = false; };
    icsnpp-bacnet = { url = "git+https://github.com/cisagov/icsnpp-bacnet"; flake = false; };
    zeek-plugin-kafka = { url = "git+https://github.com/SeisoLLC/zeek-kafka?ref=main"; flake = false; };
    spicy-analyzers = { url = "git+https://github.com/zeek/spicy-analyzers?ref=main"; flake = false; };
  };

  outputs = inputs: with builtins;
    {
      overlay = final: prev: {
        zeekMain = prev.callPackage ./nix {
          KafkaPlugin = true;
          PostgresqlPlugin = true;
          Http2Plugin = true;
          Ikev2Plugin = false; #failed Cannot determine Bro source directory, use --bro-dist=DIR.
          CommunityIdPlugin = true;
          ZipPlugin = true;
          PdfPlugin = true;
          SpicyPlugin = true;
          SpicyAnalyzersPlugin = true;
        };
        zeek-rc = (final.zeekMain.override ({
          version = "4.0.0";
        })).overrideAttrs (old: rec {
          src = inputs.zeek-rc;
        });
        zeekTLS = (final.zeekMain.override ({
          version = "4.0.1";
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
            zeek = pkgs.zeek;
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
