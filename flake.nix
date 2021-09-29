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
    nixpkgs-hardenedlinux = { url = "github:hardenedlinux/nixpkgs-hardenedlinux"; };
    nvfetcher = {
      url = "github:berberman/nvfetcher";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    microvm = {
      url = "github:astro/microvm.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: with builtins; with inputs;
    {
      overlay = final: prev: rec {
        zeek-release = prev.callPackage ./nix {
          llvmPackages = prev.llvmPackages_latest;
          plugins = [
            "zeek-plugin-kafka"
            "zeek-plugin-spicy"
            "zeek-plugin-community-id"
            "zeek-plugin-af_packet"
            #./result/bin/zeek -dZeek script debugging ON.
            # internal error in /nix/store/xrs4li5n46r0hmnvaza7gj65jbrw21c5-zeek-release-4.1.0/lib/zeek/plugins/Johanna_PostgreSQL/scripts/__preload__.zeek, line 10: Failed to fread() file data
            # recommanded change: commmtes __preload__.zeek
            # FIXME: remove postgresql and use vast instead
            # "zeek-plugin-postgresql"
          ];
        };
        zeek-latest = (final.zeek-release.overrideAttrs (old: rec {
          inherit (final.zeek-sources.zeek-latest) src pname version;
        }));

        zeek-sources = prev.callPackage ./nix/_sources/generated.nix { };

        zeek-vm-tests = prev.lib.optionalAttrs prev.stdenv.isLinux (import ./tests/nixos-test.nix
          {
            makeTest = (import (prev.path + "/nixos/tests/make-test-python.nix"));
            pkgs = final;
            inherit self;
          });

        zeek-docker = with final;
          dockerTools.buildImage {
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
              (final: prev: { btest = nixpkgs-hardenedlinux.packages."x86_64-linux".btest; })
            ];
            config = {
              allowUnsupportedSystem = true;
            };
          };
        in
        rec {
          inherit pkgs;
          packages = inputs.flake-utils.lib.flattenTree
            rec {
              zeek-release = pkgs.zeek-release;
              zeek-latest = pkgs.zeek-latest;
            } // pkgs.lib.optionalAttrs pkgs.stdenv.isLinux {
            zeek-docker = pkgs.zeek-docker;
            # nix -Lv run ./\#zeek-microvm
            # spawn shell with microvm env
            zeek-microvm = microvm.lib.runner
              {
                inherit system;
                hypervisor = "qemu";
                nixosConfig = { pkgs, ... }: {
                  networking.hostName = "zeek-microvm";
                  users.users.root.password = "";
                } // import ./tests/standalone.nix { inherit pkgs self; };
                volumes = [{
                  mountpoint = "/var";
                  image = "tests/zeek-microvm.img";
                  size = 256;
                }];
                socket = "control.socket";
              };

            inherit (pkgs.zeek-vm-tests)
              zeek-standalone-vm-systemd
              zeek-cluster-vm-systemd;
          };

          hydraJobs = {
            inherit packages;
          };

          devShell = with pkgs; devshell.mkShell {
            imports = [ (devshell.importTOML ./misc/spicy-plugin.toml) ];
            packages = [
              #zeek-release #debug
              btest
            ];
            commands = [
              {
                name = "cachix-push";
                help = "push zeek-master binary cachix to cachix";
                command = "nix-build | cachix push zeek";
              }
              {
                name = "spicy-plugin-btest";
                help = "Test";
                command = "btest -d -j -a installation && btest -d -j";
              }
              {
                name = pkgs.nvfetcher-bin.pname;
                help = pkgs.nvfetcher-bin.meta.description;
                command = "cd $PRJ_ROOT/nix; ${pkgs.nvfetcher-bin}/bin/nvfetcher -c ./sources.toml --no-output $@";
              }
            ];
          };
          #
          apps = {
            zeek-latest = inputs.flake-utils.lib.mkApp { drv = packages.zeek-latest; exePath = "/bin/zeek"; };
            zeek-release = inputs.flake-utils.lib.mkApp { drv = packages.zeek-release; exePath = "/bin/zeek"; };
            spicyz = inputs.flake-utils.lib.mkApp { drv = packages.zeek-release; exePath = "/bin/spicyz"; };
          };

          defaultPackage = packages.zeek-release;
          defaultApp = apps.zeek-release;
          checks = { } // (removeAttrs packages [ "zeek-latest" "zeek-docker" ]);
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
