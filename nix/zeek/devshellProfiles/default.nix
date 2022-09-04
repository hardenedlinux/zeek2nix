{
  inputs,
  cell,
}: {
  default = _: {
    commands = [
      {
        name = "nvfetcher-update";
        command = ''
          nix develop github:GTrunSec/cells-lab#devShells.x86_64-linux.update \
          --refresh --command \
          nvfetcher-update nix/zeek/packages/sources.toml
        '';
      }
      {
        name = "nix-github-update";
        command = "nix develop github:GTrunSec/cells-lab#devShells.x86_64-linux.update --no-write-lock-file --command nix-github-update";
        help = "run nix-github-update";
      }
    ];
  };
}
