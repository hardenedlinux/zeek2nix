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

  inputs =  {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "nixpkgs/7ff5e241a2b96fff7912b7d793a06b4374bd846c";

    zeek-tls = { url = "https://download.zeek.org/zeek-3.0.12.tar.gz"; flake = false;};
    zeek-current = { url = "https://download.zeek.org/zeek-3.2.3.tar.gz"; flake = false;};
    zeek-4 = { url = "https://download.zeek.org/zeek-4.0.0-rc2.tar.gz"; flake = false;};

    zeek-plugin-pdf = { url = "git+https://github.com/reservoirlabs/zeek-pdf-analyzer"; flake = false;}; #failure to 3.0.1
    zeek-plugin-zip = { url = "git+https://github.com/reservoirlabs/zeek-zip-analyzer"; flake = false;}; #failure to 3.0.1
    zeek-plugin-ikev2 = { url = "git+https://github.com/ukncsc/zeek-plugin-ikev2"; flake = false;}; #failure to 3.2.1
    zeek-plugin-postgresql  = { url = "git+https://github.com/0xxon/zeek-postgresql"; flake = false;};
    zeek-plugin-http2 = { url = "git+https://github.com/MITRECND/bro-http2/"; flake = false;};
    zeek-plugin-community-id = { url = "git+https://github.com/corelight/zeek-community-id/"; flake = false;};
    icsnpp-bacnet = { url = "git+https://github.com/cisagov/icsnpp-bacnet"; flake = false;};
    metron-zeek-plugin-kafka  = { url = "git+https://github.com/apache/metron-bro-plugin-kafka/"; flake = false;};
  };

  outputs = inputs: with builtins;let
    overlay = final: prev: {
      zeek4 = (prev.zeek.override({
        version = "4.0.0-rc2";
        python = prev.python3;
      })).overrideAttrs(old: rec {
        src = inputs.zeek-4;
      });
      zeekCurrent = (prev.zeek.override({
        version = "3.2.3";
        python = prev.python3;
      })).overrideAttrs(old: rec {
        src = inputs.zeek-current;
      });
      zeekTLS = (prev.zeek.override({
        version = "3.0.12";
        PdfPlugin = false; #failed
        ZipPlugin = false;  #failed
      })).overrideAttrs(old: rec {
        src = inputs.zeek-tls;
      });
    };
  in
    (inputs.flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = import inputs.nixpkgs {
            inherit system;
            overlays = [
              (import ./overlay.nix)
              overlay
            ];
          };
        in
          rec {
            packages = inputs.flake-utils.lib.flattenTree rec {
              zeekCurrent = pkgs.zeekCurrent;
              zeekTLS = pkgs.zeekTLS;
              zeek4 = pkgs.zeek4;
            };

            devShell = with pkgs; mkShell {
              buildInputs = [ pkgs.zeek4 ];
            };
            #
            apps = {
              zeekTLS = inputs.flake-utils.lib.mkApp { drv = packages.zeekTLS; exePath = "/bin/zeekctl"; };
              zeekCurrent = inputs.flake-utils.lib.mkApp { drv = packages.zeekCurrent; exePath = "/bin/zeekctl";};
              zeek4 = inputs.flake-utils.lib.mkApp { drv = packages.zeek4; exePath = "/bin/zeekctl";};
            };

            defaultPackage = packages.zeekCurrent;
            defaultApp = apps.zeekCurrent;
          }
      ) // {
        nixosModule = import ./module;
      }
    );
}
