{
  config,
  lib,
  pkgs,
  ...
}: {
  commands = [
    {
      name = "nvfetcher-update";
      command = "nix develop github:GTrunSec/DevSecOps-Cells-Lab#devShells.x86_64-linux.update --command nvfetcher-update ./nix/sources.toml";
      help = "run nvfetcher-update with your sources.toml";
    }
    {
      name = "nix-github-update";
      command = "nix develop github:GTrunSec/DevSecOps-Cells-Lab#devShells.x86_64-linux.update --command nix-github-update";
      help = "run nix-github-update";
    }
  ];
}
