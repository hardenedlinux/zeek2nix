{ inputs }:
final: prev:
{
  btest = inputs.nixpkgs-hardenedlinux.packages."${prev.stdenv.hostPlatform.system}".btest;
  spicy-sources = inputs.spicy2nix.spicy-sources."${prev.stdenv.hostPlatform.system}";

  zeek-sources = prev.callPackage ./_sources/generated.nix {};

  zeek-release = prev.callPackage ./. {
    llvmPackages = prev.llvmPackages_11;
    plugins = [
      "zeek-plugin-kafka"
      "zeek-plugin-spicy"
      "zeek-plugin-community-id"
      "zeek-plugin-af_packet"
      #./result/bin/zeek -dZeek script debugging ON.
      # internal error in /nix/store/xrs4li5n46r0hmnvaza7gj65jbrw21c5-zeek-release-4.1.0/lib/zeek/plugins/Johanna_PostgreSQL/scripts/__preload__.zeek, line 10: Failed to fread() file data
      # recommanded change: commmtes __preload__.zeek
      # FIXME: remove postgresql and use vast instead
      # "zeek-plugin-postgresql"
    ];
  };

  zeek-latest = final.zeek-release.overrideAttrs (
    old: rec { inherit (final.zeek-sources.zeek-latest) src pname version; }
  );

  zeek-vm-tests = prev.callPackage ../tests/nixos-test.nix {
    makeTest = import (prev.path + "/nixos/tests/make-test-python.nix");
    inherit inputs;
  };
}
