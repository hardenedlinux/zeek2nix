{
  stdenv,
  lib,
  fetchFromGitHub,
  zeek-sources,
  linuxPackages,
  fetchurl,
}: let
  k = linuxPackages;
  i40e = fetchurl {
    url = "https://sourceforge.net/projects/e1000/files/i40e%20stable/2.4.6/i40e-2.4.6.tar.gz";
    sha256 = "sha256-MGyiEd4dhrS1V/3sroxj+51OhI+/JxlhJ4VjwIUciHI=";
  };
  igb = fetchurl {
    url = "https://sourceforge.net/projects/e1000/files/igb%20stable/5.3.5.20/igb-5.3.5.20.tar.gz";
    sha256 = "sha256-S9YIU44SmTiPmkyS39Zqo1x2VKGg3i7xBygYyiMrmYo=";
  };
in
  stdenv.mkDerivation {
    inherit (zeek-sources.netmap) pname src version;

    preConfigure = ''
      cp --recursive --no-preserve=mode,ownership ${i40e} /build/source/LINUX/ext-drivers/i40e-2.4.6.tar.gz
      cp --recursive --no-preserve=mode,ownership ${igb} /build/source/LINUX/ext-drivers/igb-5.3.5.20.tar.gz
    '';

    configureFlags = [
      "--kernel-dir=${k.kernel.dev}/lib/modules/${k.kernel.modDirVersion}/build"
      "--kernel-sources=${k.kernel.dev}/lib/modules/${k.kernel.modDirVersion}/build"
      "--driver-suffix=-netmap"
      "--install-mod-path=${placeholder "out"}"
      #"--no-drivers"
    ];

    buildInputs = [] ++ k.kernel.moduleBuildDependencies;

    meta = with lib; {
      homepage = "https://github.com/luigirizzo/netmap";
      description = "Automatically exported from code.google.com/p/netmap";
    };
  }
