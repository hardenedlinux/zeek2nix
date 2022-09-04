{
  stdenv,
  lib,
  fetchFromGitHub,
  zeek-sources,
  linuxPackages_5_15,
}: let
  k = linuxPackages_5_15;
in
  stdenv.mkDerivation {
    inherit (zeek-sources.netmap) pname src version;
    preConfigure = ''
    '';
    configureFlags = [
      "--kernel-dir=${k.kernel.dev}/lib/modules/5.15.39/build"
      "--install-mod-path=${placeholder "out"}"
      #"--no-drivers"
    ];

    buildInputs = [] ++ k.kernel.moduleBuildDependencies;

    meta = with lib; {
      homepage = "https://github.com/luigirizzo/netmap";
      description = "Automatically exported from code.google.com/p/netmap";
    };
  }
