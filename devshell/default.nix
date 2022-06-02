{
  config,
  lib,
  pkgs,
  ...
}: {
  commands = [
    {
      name = "nvfetcher-update";
      command = "nix develop github:GTrunSec/cells-lab#devShells.x86_64-linux.update --no-write-lock-file --command nvfetcher-update ./nix/sources.toml";
      help = "run nvfetcher-update with your sources.toml";
    }
    {
      name = "nix-github-update";
      command = "nix develop github:GTrunSec/cells-lab#devShells.x86_64-linux.update --no-write-lock-file --command nix-github-update";
      help = "run nix-github-update";
    }
  ];
}
