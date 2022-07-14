{
  inputs,
  cell,
}: let
  inherit (cell.library) nixpkgs;
in {
  inherit (nixpkgs) zeek;
  mkZeek = nixpkgs.zeekWithPlugins {
    plugins = [
      {
        src = nixpkgs.zeek-sources.zeek-plugin-community-id;
      }
    ];
  };
  zeek-fix =
    nixpkgs.runCommand "zeek-fix" {
    } ''
      mkdir -p $out
      cp -r ${nixpkgs.zeek-sources.zeek-plugin-community-id.src} ${nixpkgs.zeek-sources.zeek-plugin-community-id.pname}
    '';
}
