{
  inputs,
  cell,
}: let
  inherit (cell.library) nixpkgs;
  plugins = [
    {
      src = nixpkgs.zeek-sources.zeek-community-id;
    }
    # {
    #   src = nixpkgs.zeek-sources.zeek-netmap;
    #   buildInputs = [nixpkgs.netmap];
    # }
    {
      src = nixpkgs.zeek-sources.zeek-af_packet;
    }
    {
      src = nixpkgs.zeek-sources.zeek-dpdk;
      buildInputs = [nixpkgs.dpdk];
      env = [
        "CXXFLAGS=\"-march=x86-64 -msse4.1 -msse3\""
        "CFLAGS=\"-march=x86-64 -msse4.1 -msse3\""
      ];
    }
  ];
in {
  inherit (nixpkgs) zeek zeek-release netmap zeek-latest;

  zeekStatic = nixpkgs.pkgsStatic.zeek;

  mkZeek = nixpkgs.zeekWithPlugins {
    inherit plugins;
  };

  mkZeekPluginCI = nixpkgs.zeekPluginCi {
    plugins = [
      # {
      #   src = nixpkgs.zeek-sources.zeek-netmap;
      #   buildInputs = [nixpkgs.netmap];
      # }
      {
        src = nixpkgs.zeek-sources.zeek-dpdk;
        buildInputs = [nixpkgs.dpdk];
        # gcc g++

        env = [
          "CXXFLAGS=\"-march=x86-64 -msse4.1 -msse3\""
          "CFLAGS=\"-march=x86-64 -msse4.1 -msse3\""
        ];
      }
      # {
      #   src = nixpkgs.zeek-sources.zeek-xdp_packet;
      #   buildInputs = [nixpkgs.libbpf];
      #   args = let
      #     k = nixpkgs.linuxPackages;
      #   in [
      #     "--with-kernel=${k.kernel.dev}/lib/modules/${k.kernel.modDirVersion}/build"
      #     "--with-bpf=${nixpkgs.libbpf}"
      #     "--with-clang=${nixpkgs.clang}/bin/clang"
      #     "--with-llc=${nixpkgs.llvmPackages.llvm}/bin/llc"
      #   ];
      # }
      # {
      #   src = nixpkgs.zeek-sources.zeek-af_packet;
      # }
      # {
      #   src = nixpkgs.zeek-sources.zeek-community-id;
      # }
    ];
  };

  inherit
    (nixpkgs.zeek-vm-tests)
    zeek-cluster-vm-systemd
    zeek-standalone-vm-systemd
    ;
}
