{
  description = "Zeek to Nix";
  nixConfig.extra-substituters = "https://zeek.cachix.org";
  nixConfig.extra-trusted-public-keys = "zeek.cachix.org-1:Jv0hB/P5eF7RQUZgSQiVqzqzgweP29YIwpSiukGlDWQ=";
  nixConfig = {
    flake-registry = "https://github.com/hardenedlinux/flake-registry/raw/main/flake-registry.json";
    #flake-registry = "/home/gtrun/ghq/github.com/hardenedlinux/flake-registry/flake-registry.json";
  };

  inputs = {
    spicy2nix = { url = "github:GTrunSec/spicy2nix"; };
    flake-compat.flake = false;
    # Fixup input tempalte
    # zeek2nix = {
    #   url = "github:hardenedlinux/zeek2nix";
    #   inputs.microvm.follows = "zeek2nix/nixpkgs-hardenedlinux/microvm";
    # };
  };

  outputs =
    { self
    , nixpkgs_21_05
    , flake-utils
    , flake-compat
    , devshell
    , nixpkgs-hardenedlinux
    , microvm
    , spicy2nix
    , ...
    }@inputs:
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
        zeek-latest = final.zeek-release.overrideAttrs (old: rec {
          inherit (final.zeek-sources.zeek-latest) src pname version;
        });

        zeek-sources = prev.callPackage ./nix/_sources/generated.nix { };

        zeek-vm-tests = prev.lib.optionalAttrs prev.stdenv.isLinux (import ./tests/nixos-test.nix
          {
            makeTest = import (prev.path + "/nixos/tests/make-test-python.nix");
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
    (inputs.flake-utils.lib.eachDefaultSystem
      (system:
      let
        pkgs = import nixpkgs_21_05 {
          inherit system;
          overlays = [
            self.overlay
            devshell.overlay
            spicy2nix.overlay
            (final: prev: { inherit (nixpkgs-hardenedlinux.packages."x86_64-linux") btest; })
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
            inherit (pkgs)
              zeek-release
              zeek-latest;
          } // pkgs.lib.optionalAttrs pkgs.stdenv.isLinux {
          inherit (pkgs) zeek-docker;
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
              interfaces = [{
                type = "bridge,br=virbr0";
                id = "qemu-eth0";
                mac = "00:02:00:01:01:01";
              }];
              volumes = [{
                mountpoint = "/var";
                image = "/tmp/zeek-microvm.img";
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

        devShell = with pkgs; pkgs.devshell.mkShell {
          imports = [
            (pkgs.devshell.importTOML ./misc/spicy-plugin.toml)
            (pkgs.devshell.importTOML ./devshell.toml)
          ];
          packages = [
            #zeek-release #debug
            btest
          ];
          commands = [
            {
              name = "cachix-push";
              help = "push zeek-master binary cachix to cachix";
              command = ''
                nix -Lv build .\#zeek-release --no-link --json | jq -r '.[].outputs | to_entries[].value' | cachix push zeek
                nix -Lv build .\#zeek-microvm --no-link --json | jq -r '.[].outputs | to_entries[].value' | cachix push zeek
              '';
            }
            {
              name = "spicy-plugin-btest";
              help = "Test";
              command = "btest -d -j -a installation && btest -d -j";
            }
          ];
        };
        #
        apps = {
          zeek-latest = inputs.flake-utils.lib.mkApp { drv = packages.zeek-latest; exePath = "/bin/zeek"; };
          zeek-release = inputs.flake-utils.lib.mkApp { drv = packages.zeek-release; exePath = "/bin/zeek"; };
          spicyz = inputs.flake-utils.lib.mkApp { drv = packages.zeek-release; exePath = "/bin/spicyz"; };
          checks = flake-utils.lib.mkApp {
            drv = with pkgs; writeShellScriptBin "checks" (''
                ''
            + (lib.fileContents ./tests/test.sh));
          };
        };

        defaultPackage = packages.zeek-release;
        defaultApp = apps.zeek-release;
        checks = { } // (removeAttrs packages [ "zeek-latest" "zeek-docker" "zeek-release" ]);
      }
      ) // {
      nixosModules = {
        zeek = {
          imports = [
            {
              nixpkgs.config.packageOverrides = pkgs: {
                inherit (self.packages."${pkgs.system}") zeek-release;
              };
            }
            ./module
          ];
        };
      };
    });
}
