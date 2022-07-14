{
  inputs,
  cell,
} @ args: {
  default = prev: final: rec {
    zeek-sources = prev.callPackage ../packages/_sources/generated.nix {};

    zeek = prev.callPackage ../packages/zeek.nix {};

    zeekWithPlugins = {plugins, ...} @ _args: let
      buildPlugins = prev.lib.flip prev.lib.concatMapStrings plugins (
        {
          src,
          arg ? "--zeek-dist=/build/source",
        }: ''
          cp -r ${builtins.toPath src.src} /build/${src.pname}
          chmod -R +rw /build/${src.pname} && cd /build/${src.pname}
          ./configure ${arg}
          make -j $NIX_BUILD_CORES && make install
        ''
      );
    in
      zeek.overrideAttrs (old:
        {
          preFixup = old.preFixup + buildPlugins;
        }
        // (builtins.removeAttrs _args ["plugins"]));
  };
  nixos-test = import ./nixos args;
}
