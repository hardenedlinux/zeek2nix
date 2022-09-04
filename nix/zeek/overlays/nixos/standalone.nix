{
  pkgs,
  inputs,
  cell,
  ...
}: let
  # zeek2nix = import (builtins.fetchTarball {
  #   name = "zeek2nix";
  #   url = "https://github.com/GTrunSec/photoprism2nix/archive/<rev>.tar.gz";
  #   sha256 = "sha256:0yqj3bg5mkz4ivpgx2agwq324sr8psdgd169f1s4kfi7krpds7l8";
  # });
in {
  # imports = [zeek2nix.nixosModules.zeek];
  imports = [cell.nixosModules.zeek];
  environment.systemPackages = [
    cell.packages.zeek-release
    pkgs.coreutils
    pkgs.gnugrep
  ];
  services.zeek = {
    enable = true;
    standalone = true;
    interface = "eth0";
    host = "127.0.0.1";
    # package = zeek2nix.packages.zeek-release;
    package = cell.packages.zeek-release.override {};
    privateScripts = ''
      @load ${./scripts/zeek-query.zeek}

      @load ${./scripts/http_remove.zeek}
    '';
    #./result/bin/spicyc -j -o misc/my-http.hlto misc/my-http.spicy
    # FIXME:
    # privateSpicyScripts = [ ./misc/my-http.hlto ];
  };
}
