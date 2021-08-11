{
  description = "Zeek to Nix";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "nixpkgs/release-21.05";
    flake-compat = { url = "github:edolstra/flake-compat"; flake = false; };
    devshell-flake = { url = "github:numtide/devshell"; };
    spicy2nix = { url = "github:GTrunSec/spicy2nix"; };
    nvfetcher = {
      url = "github:berberman/nvfetcher";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: with builtins; with inputs;
    {
      overlay = final: prev: {
        zeek-release = prev.callPackage ./nix {
          llvmPackages = prev.llvmPackages_latest;
          KafkaPlugin = true;
          PostgresqlPlugin = true;
          Http2Plugin = false; #4.1.0
          Ikev2Plugin = false; #failed Cannot determine Bro source directory, use --bro-dist=DIR.
          CommunityIdPlugin = true;
          ZipPlugin = false; #4.1.0
          PdfPlugin = false; #4.1.0
          SpicyPlugin = true;
        };
        zeek-latest = (final.zeek-release.overrideAttrs (old: rec {
          inherit (final.zeek-sources.zeek-latest) src pname version;
        }));
        zeek-sources = prev.callPackage ./nix/_sources/generated.nix { };

        zeek-vm-tests = prev.lib.optionalAttrs prev.stdenv.isLinux (import ./nixos-test.nix
          {
            makeTest = (import (prev.path + "/nixos/tests/make-test-python.nix"));
            pkgs = final;
            inherit self;
          });
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
              nvfetcher.overlay
              spicy2nix.overlay
            ];
            config = {
              allowUnsupportedSystem = true;
            };
          };
        in
        rec {
          packages = inputs.flake-utils.lib.flattenTree
            rec {
              zeek-release = pkgs.zeek-release;
              zeek-latest = pkgs.zeek-latest;
            } // pkgs.lib.optionalAttrs pkgs.stdenv.isLinux {
            inherit (pkgs.zeek-vm-tests)
              zeek-vm-systemd;
          };

          hydraJobs = {
            inherit packages;
          };

          devShell = with pkgs; devshell.mkShell {
            packages = [ cachix ];
            commands = [
              {
                name = "cachix-push";
                help = "push zeek-master binary cachix to cachix";
                command = "nix-build | cachix push zeek";
              }
              {
                name = pkgs.nvfetcher-bin.pname;
                help = pkgs.nvfetcher-bin.meta.description;
                command = "cd $DEVSHELL_ROOT/nix; ${pkgs.nvfetcher-bin}/bin/nvfetcher -c ./sources.toml --no-output $@";
              }
            ];
          };
          #
          apps = {
            zeek-latest = inputs.flake-utils.lib.mkApp { drv = packages.zeek-latest; exePath = "/bin/zeek"; };
            zeek-release = inputs.flake-utils.lib.mkApp { drv = packages.zeek-release; exePath = "/bin/zeek"; };
          };

          defaultPackage = packages.zeek-release;
          defaultApp = apps.zeek-release;
        }
      ) // {
      nixosModules = {
        zeek = { ... }: {
          imports = [
            {
              nixpkgs.config.packageOverrides = pkgs: {
                inherit (self.packages.${pkgs.system}) zeek-release;
              };
            }
            ./module
          ];
        };
      };
    });
}
