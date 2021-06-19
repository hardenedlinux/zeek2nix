{
  description = "Zeek to Nix";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "nixpkgs/release-21.05";
    flake-compat = { url = "github:edolstra/flake-compat"; flake = false; };
    devshell-flake = { url = "github:numtide/devshell"; };
    nvfetcher-flake = {
      url = "github:berberman/nvfetcher";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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

  outputs = inputs: with builtins; with inputs;
    {
      overlay = final: prev: {
        zeek-release = prev.callPackage ./nix {
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
        zeek-master = (final.zeek-release.overrideAttrs (old: rec {
          inherit (final.sources.zeek-master) src pname version;
        }));
      };
    } //
    (inputs.flake-utils.lib.eachSystem [ "x86_64-linux" "x86_64-darwin" ]
      (system:
        let
          pkgs = import inputs.nixpkgs {
            inherit system;
            overlays = [
              self.overlay
              devshell-flake.overlay
              nvfetcher-flake.overlay
              (final: prev: { sources = prev.callPackage (import ./nix/_sources/generated.nix) { }; })
            ];
            config = {
              allowUnsupportedSystem = true;
            };
          };
        in
        rec {
          packages = inputs.flake-utils.lib.flattenTree rec {
            zeek-release = pkgs.zeek-release;
            zeek-master = pkgs.zeek-master;
          };

          hydraJobs = {
            inherit packages;
          };

          devShell = with pkgs; devshell.mkShell {
            commands = [
              {
                name = pkgs.nvfetcher-bin.pname;
                help = pkgs.nvfetcher-bin.meta.description;
                command = "cd $DEVSHELL_ROOT/nix; ${pkgs.nvfetcher-bin}/bin/nvfetcher -c ./sources.toml --no-output $@";
              }
            ];
          };
          #
          apps = {
            zeek-master = inputs.flake-utils.lib.mkApp { drv = packages.zeek-master; exePath = "/bin/zeek"; };
            zeek-release = inputs.flake-utils.lib.mkApp { drv = packages.zeek-release; exePath = "/bin/zeek"; };
          };

          defaultPackage = packages.zeek-release;
          defaultApp = apps.zeek-release;
        }
      ) // {
      nixosModules = {
        zeek = import ./module;
      };
    });
}
