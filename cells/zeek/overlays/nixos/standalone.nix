{
  pkgs,
  inputs,
  cell,
  ...
}: {
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
