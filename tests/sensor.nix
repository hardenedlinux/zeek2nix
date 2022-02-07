{ pkgs
, inputs
, ...
}:
{
  imports = [ inputs.self.nixosModules.zeek ];
  environment.systemPackages = [ inputs.self.packages."${pkgs.system}".zeek-release pkgs.coreutils ];
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC83r2CCh6kWQ5liGNavwlk5NR+j5uqdNNKa4pjb45Ij zeek-cluster"
  ];
  services.openssh = {
    enable = true;
    permitRootLogin = "yes";
  };
  networking = {
    dhcpcd.enable = false;
    useNetworkd = true;
    useDHCP = false;
    interfaces.eth0.ipv4.addresses = pkgs.lib.mkForce [
      {
        address = "192.168.1.2";
        prefixLength = 24;
      }
    ];
  };
  services.zeek = {
    enable = true;
    sensor = true;
  };
}
