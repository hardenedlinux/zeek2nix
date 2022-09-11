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

    zeek-latest = zeek.overrideAttrs (
      old: {
        inherit (zeek-sources.zeek-latest) src pname version;
      }
    );

    zeekWithPlugins = {
      plugins,
      package ? zeek,
      ...
    } @ _args: let
      pluginInputs = builtins.concatMap ({
        src,
        buildInputs ? [],
      }:
        [] ++ buildInputs)
      plugins;

      buildPlugins = prev.lib.flip prev.lib.concatMapStrings plugins (
        {
          src,
          buildInputs ? [],
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
      package.overrideAttrs (old:
        {
          preFixup = old.preFixup + buildPlugins;
          buildInputs = old.buildInputs ++ pluginInputs;
        }
        // (builtins.removeAttrs _args ["plugins"]));

    zeekPluginCi = {
      plugins,
      buildInputs ? [],
    } @ _args: let
      buildInputs = builtins.concatMap ({
        src,
        buildInputs ? [],
      }:
        [] ++ buildInputs)
      plugins;

      buildPlugins = prev.lib.flip prev.lib.concatMapStrings plugins (
        {
          src,
          buildInputs ? [],
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
      prev.runCommand "zeek-plugins-ci" {
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

  static = final: prev: let
    inherit (final.stdenv.hostPlatform) isStatic;
  in {
  };

  nixos-test = import ./nixos args;
}
