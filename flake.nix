{
  description = "Zeek to Nix";
  nixConfig.extra-substituters = "https://zeek.cachix.org";
  nixConfig.extra-trusted-public-keys = "zeek.cachix.org-1:Jv0hB/P5eF7RQUZgSQiVqzqzgweP29YIwpSiukGlDWQ=";
  nixConfig = {
    flake-registry = "https://github.com/hardenedlinux/flake-registry/raw/main/flake-registry.json";
  };
  inputs = {
    flake-compat.flake = false;
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };
  outputs = {
    self,
    nixpkgs,
    flake-utils,
    flake-compat,
    nixpkgs-hardenedlinux,
    spicy2nix,
    devshell,
    ...
  } @ inputs: (
    inputs.flake-utils.lib.eachDefaultSystem
    (
      system: let
        pkgs = inputs.nixpkgs.legacyPackages."${system}".appendOverlays [self.overlays.default];
        devshell = inputs.devshell.legacyPackages."${system}";
        btest = inputs.nixpkgs-hardenedlinux.packages.${system}.btest;
      in rec {
        inherit (pkgs) zeek-sources;
        packages =
          {
            inherit (pkgs) zeek-release zeek-latest;
            inherit btest;
            default = packages.zeek-release;
          }
          // pkgs.lib.optionalAttrs pkgs.stdenv.isLinux
          {
            inherit (pkgs.zeek-vm-tests) zeek-standalone-vm-systemd zeek-cluster-vm-systemd;
          };

        hydraJobs = {inherit packages;};
        devShells.default = devshell.mkShell {imports = [./devshell];};

        apps = rec {
          default = zeek-release;
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
      }
    )
    // {
      overlays = import ./nix/overlays.nix {inherit inputs;};
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
