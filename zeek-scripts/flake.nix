{
  description = "Zeek to Nix";

  inputs =  {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "nixpkgs/302ef60620d277fc87a8aa58c5c561b62c925651";

    CVE-2020-16898 = { url = "github:corelight/CVE-2020-16898"; flake = false; };

    zeek-known-hosts-with-dns = { url = "github:dopheide-esnet/zeek-known-hosts-with-dns"; flake = false; };
    #CONN
    zeek-long-connections = { url = "github:corelight/bro-long-connections"; flake = false; };
    conn-burst = { url = "github:corelight/conn-burst"; flake = false; };
    #DNS
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
            { }
        )
    );
}
