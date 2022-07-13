{
  config,
  lib,
  pkgs,
  ...
}: {
  commands = [
    {
      name = "nvfetcher-update";
      command = "nix develop github:GTrunSec/cells-lab#devShells.x86_64-linux.update --refresh --no-write-lock-file --command nvfetcher-update ./nix/sources.toml";
      help = "run nvfetcher-update with your sources.toml";
    }
  ];
}
