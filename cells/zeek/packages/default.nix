{
  inputs,
  cell,
}: let
  nixpkgs = inputs.nixpkgs.appendOverlays [
    cell.overlays.default
  ];
in rec {
  zeek = inputs.nixpkgs.callPackage ./zeek.nix {};
  zeek-withPlugins = let
    plugins = [
      {
        src = nixpkgs.zeek-sources.zeek-plugin-community-id;
      }
    ];
    buildPlugins = nixpkgs.lib.flip nixpkgs.lib.concatMapStrings plugins (
      {
        src,
        arg ? "--zeek-dist=/build/source",
      }: ''
        cp -r ${builtins.toPath src.src} /build/${src.pname}
        cd /build/${src.pname}
        ./configure ${arg}
        make -j $NIX_BUILD_CORES && make install
      ''
    );
  in
    zeek.overrideAttrs (old: {
      preFixup =
        old.preFixup
        + buildPlugins
        + ''
        '';
    });
}
