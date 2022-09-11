{
  stdenv,
  lib,
  fetchFromGitHub,
  zeek-sources,
  linuxPackages,
}: let
  k = linuxPackages;
in
  stdenv.mkDerivation {
    inherit (zeek-sources.netmap) pname src version;

    configureFlags = [
      "--kernel-dir=${k.kernel.dev}/lib/modules/${k.kernel.modDirVersion}/build"
      "--install-mod-path=${placeholder "out"}"
      #"--no-drivers"
    ];

    buildInputs = [] ++ k.kernel.moduleBuildDependencies;

    meta = with lib; {
      homepage = "https://github.com/luigirizzo/netmap";
      description = "Automatically exported from code.google.com/p/netmap";
    };
  }
