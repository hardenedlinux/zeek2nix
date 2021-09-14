{ pkgs, self, ... }:
{
  imports = [
    self.nixosModules.zeek
  ];
  environment.systemPackages = [
    self.packages."${pkgs.system}".zeek-release
    pkgs.coreutils
    pkgs.gnugrep
  ];

  services.zeek = {
    enable = true;
    standalone = true;
    interface = "eth0";
    host = "127.0.0.1";
    package = self.packages."${pkgs.system}".zeek-release.override { };
    privateScripts = ''
      @load ${../misc/zeek-query.zeek}

      @load ${../misc/http_remove.zeek}
    '';
    #./result/bin/spicyc -j -o misc/my-http.hlto misc/my-http.spicy
    # FIXME:
    # privateSpicyScripts = [ ./misc/my-http.hlto ];
  };
}
