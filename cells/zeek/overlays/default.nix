{
  inputs,
  cell,
} @ args: {
  default = prev: final: rec {
    zeek-sources = prev.callPackage ../packages/_sources/generated.nix {};

    pf_ring = prev.callPackage ../packages/pr_ring.nix {};

    netmap = prev.callPackage ../packages/netmap.nix {};

    zeek = prev.callPackage ../packages/zeek.nix {};

    zeek-release = zeek;

    zeekWithPlugins = {plugins, ...} @ _args: let
      buildPlugins = prev.lib.flip prev.lib.concatMapStrings plugins (
        {
          src,
          arg ? "--zeek-dist=/build/source",
        }: ''
          export ZEEK_DIST=${placeholder "out"};
          cp -r ${src.src} /build/${src.pname}
          chmod -R +rw /build/${src.pname} && cd /build/${src.pname}
          ./configure ${arg}
          cd build
          make -j $NIX_BUILD_CORES && make install
        ''
      );
    in
      zeek.overrideAttrs (old:
        {
          preFixup = old.preFixup + buildPlugins;
        }
        // (builtins.removeAttrs _args ["plugins"]));

    zeekPluginCi = {
      plugins,
      buildInputs ? [],
    } @ _args: let
      buildPlugins = prev.lib.flip prev.lib.concatMapStrings plugins (
        {
          src,
          arg ? "--zeek-dist=/build/source",
        }: ''
          cp -r ${src.src} /build/${src.pname}
          chmod -R +rw /build/${src.pname} && cd /build/${src.pname}
          ./configure ${arg}
          cd build
          make -j $NIX_BUILD_CORES
        ''
      );
    in
      prev.runCommand "zeek-fix" {
        inherit (zeek) nativeBuildInputs;
        buildInputs = buildInputs ++ [prev.gcc] ++ zeek.buildInputs;
      } ''
        mkdir -p $out
        cp -r ${zeek.src} /build/source && chmod -R +rw /build/source
        mkdir -p /build/source/build
        tar -xvf ${zeek}/include/zeek-dist.tar.gz -C /build/source/build
        chmod -R +rw /build/source
        ${buildPlugins}
      '';
  };

  nixos-test = import ./nixos args;
}
