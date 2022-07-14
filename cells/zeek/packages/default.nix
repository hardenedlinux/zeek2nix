{
  inputs,
  cell,
}: let
  inherit (cell.library) nixpkgs;
  plugins = [
    # {
    #   src = nixpkgs.zeek-sources.zeek-plugin-community-id;
    # }
    {
      src = nixpkgs.zeek-sources.zeek-netmap;
    }
  ];
in {
  inherit (nixpkgs) zeek zeek-release netmap;

  mkZeek = nixpkgs.zeekWithPlugins {
    inherit plugins;
  };

  mkZeekPluginCI = nixpkgs.zeekPluginCi {
    inherit plugins;
    buildInputs = [nixpkgs.netmap];
  };

  inherit
    (nixpkgs.zeek-vm-tests)
    zeek-cluster-vm-systemd
    zeek-standalone-vm-systemd
    ;
}
