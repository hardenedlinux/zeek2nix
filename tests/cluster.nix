{
  pkgs,
  inputs,
  ...
}:
with pkgs.lib; {
  imports = [ inputs.self.nixosModules.zeek ];
  environment.systemPackages = [ inputs.self.packages."${pkgs.system}".zeek-release ];
  services.openssh = {
    enable = true;
    permitRootLogin = "yes";
  };
  programs.ssh.extraConfig = ''
    UserKnownHostsFile=/dev/null
    StrictHostKeyChecking=no
    IdentityFile /etc/zeekSshKey
  '';
  environment.etc.zeekSshKey = {
    mode = "0600";
    source = ../module/zeek-cluster;
  };
  networking = {
    dhcpcd.enable = false;
    useNetworkd = true;
    useDHCP = false;
    interfaces.eth0.ipv4.addresses = mkForce [
      {
        address = "192.168.1.1";
        prefixLength = 24;
      }
    ];
  };
  # proxy login
  services.zeek = rec {
    enable = true;
    interface = "eth0";
    host = "192.168.1.1";
    node = ''
      [logger]
      type = logger
      host=${host}

      [manager]
      type=manager
      host=${host}

      [proxy-1]
      type=proxy
      host=${host}

      [worker-1]
      type=worker
      host=${host}
      interface=af_packet::${interface}
      lb_method=custom
      lb_procs=1
      pin_cpus=0,1

      [worker-2]
      type=worker
      host=192.168.1.2
      interface=af_packet::${interface}
      lb_method=custom
      lb_procs=1
      pin_cpus=0,1
    '';
    package = inputs.self.packages."${pkgs.system}".zeek-release.override { };
  };
}
