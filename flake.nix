{
  description = "Zeek to Nix";
  nixConfig.extra-substituters = "https://zeek.cachix.org";
  nixConfig.extra-trusted-public-keys = "zeek.cachix.org-1:pI1yRThH7gSh0ty7WmMWXqYFYigjcXFwiGiaaMmVpfA=";

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
          plugins = [
            "zeek-plugin-kafka"
            "zeek-plugin-spicy" #FIXME: failed with unknown error
            "zeek-plugin-community-id"
            "zeek-plugin-af_packet"
            "zeek-plugin-postgresql"
          ];
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

        zeek-docker = with final; dockerTools.buildImage {
          name = "zeek-docker";
          tag = "latest";
          contents = [
            zeek-release
            coreutils
            zsh
          ];
          runAsRoot = ''
            #!${pkgs.runtimeShell}
            mkdir -p /var/lib/zeek
            #Is there need to run the pre-run-zeelctl.sh?
          '';
          config = {
            Cmd = [ "/bin/zeek" ];
            WorkingDir = "/var/lib/zeek";
            Volumes = { "/var/lib/zeek" = { }; };
          };
        };
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
            zeek-docker = pkgs.zeek-docker;
            inherit (pkgs.zeek-vm-tests)
              zeek-standalone-vm-systemd
              zeek-cluster-vm-systemd;
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
