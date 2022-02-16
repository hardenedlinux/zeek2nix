{
  description = "Zeek to Nix";
  nixConfig.extra-substituters = "https://zeek.cachix.org";
  nixConfig.extra-trusted-public-keys = "zeek.cachix.org-1:Jv0hB/P5eF7RQUZgSQiVqzqzgweP29YIwpSiukGlDWQ=";
  nixConfig = {
    flake-registry = "https://github.com/hardenedlinux/flake-registry/raw/main/flake-registry.json";
  };
  inputs = {
    flake-compat.flake = false;
  };
  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      flake-compat,
      nixpkgs-hardenedlinux,
      spicy2nix,
      ...
    }
    @ inputs:
    (
      inputs.flake-utils.lib.eachDefaultSystem
      (
        system: let
          overlay = import ./nix/overlay.nix { inherit inputs; };
          pkgs = inputs.nixpkgs.legacyPackages."${system}".appendOverlays [ overlay ];
          devshell = inputs.devshell.legacyPackages."${system}";
          btest = inputs.nixpkgs-hardenedlinux.packages.${system}.btest;
        in
          rec {
            inherit (pkgs) zeek-sources;
            inherit overlay;
            packages =
              {
                inherit (pkgs) zeek-release zeek-latest;
                inherit btest;
              }
              // pkgs.lib.optionalAttrs pkgs.stdenv.isLinux
              {
                inherit (pkgs.zeek-vm-tests) zeek-standalone-vm-systemd zeek-cluster-vm-systemd;
              };

            hydraJobs = { inherit packages; };

            # devShell = devshell.mkShell {};
            #
            apps = {
              zeek-latest = inputs.flake-utils.lib.mkApp {
                drv = packages.zeek-latest;
                exePath = "/bin/zeek";
              };
              zeek-release = inputs.flake-utils.lib.mkApp {
                drv = packages.zeek-release;
                exePath = "/bin/zeek";
              };
              spicyz = inputs.flake-utils.lib.mkApp {
                drv = packages.zeek-release;
                exePath = "/bin/spicyz";
              };
            };
            defaultPackage = packages.zeek-release;
            defaultApp = apps.zeek-release;
          }
      )
      // {
        nixosModules = {
          zeek = {
            imports = [
              {
                nixpkgs.config.packageOverrides = pkgs: {
                  inherit (inputs.self.packages."${pkgs.stdenv.hostPlatform.system}") zeek-release;
                };
              }
              ./module
            ];
          };
        };
      }
    );
}
