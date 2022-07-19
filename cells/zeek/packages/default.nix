{
  inputs,
  cell,
}: let
  inherit (cell.library) nixpkgs;
  plugins = [
    {
      src = nixpkgs.zeek-sources.zeek-community-id;
    }
  ];
in {
  inherit (nixpkgs) zeek zeek-release netmap zeek-latest;

  mkZeek = nixpkgs.zeekWithPlugins {
    inherit plugins;
  };

  mkZeekPluginCI = nixpkgs.zeekPluginCi {
    plugins = [
      {
        src = nixpkgs.zeek-sources.zeek-netmap;
      }
    ];
    buildInputs = [nixpkgs.netmap];
  };

  inherit
    (nixpkgs.zeek-vm-tests)
    zeek-cluster-vm-systemd
    zeek-standalone-vm-systemd
    ;
}
