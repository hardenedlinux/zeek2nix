{
  description = "Zeek to Nix";

  inputs =  {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "nixpkgs/302ef60620d277fc87a8aa58c5c561b62c925651";

    #CVE detection
    CVE-2020-16898 = { url = "github:corelight/CVE-2020-16898"; flake = false; };
    CVE-2020-14882-weblogicRCE = { url = "github:corelight/CVE-2020-14882-weblogicRCE"; flake = false; };
    #Vlan
    log-add-vlan-everywhere = { url = "github:GTrunSec/log-add-vlan-everywhere/update-zeek3"; flake = false; };

    #CONN
    zeek-long-connections = { url = "github:corelight/bro-long-connections"; flake = false; };
    conn-burst = { url = "github:GTrunSec/conn-burst/update-zeek3"; flake = false; };

    #DNS
    zeek-known-hosts-with-dns = { url = "github:dopheide-esnet/zeek-known-hosts-with-dns"; flake = false; };
    dns-tunnels = { url = "github:hhzzk/dns-tunnels"; flake = false; };
    dns-axfr = { url = "github:srozb/dns_axfr"; flake = false; };
    top-dns = { url = "github:corelight/top-dns"; flake = false; };
  };


  outputs = inputs: with builtins;
    (inputs.flake-utils.lib.eachDefaultSystem
        (system:
          let
            pkgs = import inputs.nixpkgs {
              inherit system;
            };
          in
            {
              defaultPackage = import ./default.nix {inherit pkgs;};
            }
        )
    );
}
