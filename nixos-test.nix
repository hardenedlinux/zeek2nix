{ makeTest, pkgs, self }:
{
  zeek-standalone-vm-systemd = makeTest
    {
      name = "zeek-standalone-vm-systemd";
      machine = { config, pkgs, ... }: {
        imports = [
          self.nixosModules.zeek
        ];
        environment.systemPackages = [
          self.packages."${pkgs.system}".zeek-release
          pkgs.coreutils
          pkgs.gnugrep
        ];

        virtualisation.memorySize = 2046;

        services.zeek = {
          enable = true;
          standalone = true;
          interface = "eth0";
          host = "127.0.0.1";
          package = self.packages."${pkgs.system}".zeek-release.override { };
          privateScripts = ''
            @load ${./misc/zeek-query.zeek}

            @load ${./misc/http_remove.zeek}
          '';
          #./result/bin/spicyc -j -o misc/my-http.hlto misc/my-http.spicy
          # FIXME:
          # privateSpicyScripts = [ ./misc/my-http.hlto ];
        };
      };
      testScript = ''
        start_all()
        machine.wait_for_unit("network.target")
        machine.wait_for_unit("zeek.service")
        machine.sleep(5)
        print(machine.succeed("ls -il /var/lib/zeek"))
        print(machine.succeed("zeekctl status"))
        print(machine.succeed("ls -il /var/lib/zeek/zeek-spicy/modules"))
        machine.sleep(5)
        # for privateScripts
        machine.wait_for_file("/var/lib/zeek/spool/zeek/loaded_scripts.log")
        print(machine.succeed("cat /var/lib/zeek/spool/zeek/loaded_scripts.log | grep 'zeek-query.zeek\|http_remove.zeek'"))
      '';
    }
    {
      inherit pkgs;
      inherit (pkgs) system;
    };

  zeek-cluster-vm-systemd = makeTest
    {
      name = "zeek-cluster-vm-systemd";

      nodes = {
        machine = { config, pkgs, lib, ... }: with lib;{
          imports = [
            self.nixosModules.zeek
          ];

          environment.systemPackages = [
            self.packages."${pkgs.system}".zeek-release
          ];

          virtualisation = {
            memorySize = 4046;
            cores = 4;
          };

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
            source = ./module/zeek-cluster;
          };

          networking = {
            dhcpcd.enable = false;
            useNetworkd = true;
            useDHCP = false;
            interfaces.eth0.ipv4.addresses = mkForce [{ address = "192.168.1.1"; prefixLength = 24; }];
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
              lb_procs=2
              pin_cpus=0,1,2

              [worker-2]
              type=worker
              host=192.168.1.2
              interface=af_packet::${interface}
              lb_method=custom
              lb_procs=2
              pin_cpus=0,1,2
            '';
            package = self.packages."${pkgs.system}".zeek-release.override { };
          };
        };

        sensor = { config, pkgs, lib, ... }: with lib;{
          imports = [
            self.nixosModules.zeek
          ];

          virtualisation = {
            memorySize = 4046;
            cores = 4;
          };

          environment.systemPackages = [
            self.packages."${pkgs.system}".zeek-release
            pkgs.coreutils
          ];

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
            interfaces.eth0.ipv4.addresses = mkForce [{ address = "192.168.1.2"; prefixLength = 24; }];
          };

          services.zeek = {
            enable = true;
            sensor = true;
          };
        };
      };
      testScript = { nodes, ... }: ''
        start_all()
        machine.wait_for_unit("network-online.target")
        machine.wait_for_unit("sshd.service")
        sensor.wait_for_unit("network-online.target")
        sensor.wait_for_unit("sshd.service")
        sensor.wait_for_unit("zeek.service")

        machine.wait_for_unit("zeek.service")

        machine.sleep(5)
        print(machine.succeed("ls -il /var/lib/zeek"))

        #check broker default port
        machine.wait_for_open_port(47761)
        print(machine.succeed("zeekctl status"))

        sensor.wait_for_unit("zeek.service")
        print(sensor.succeed("systemctl status zeek.service"))
      '';
    }
    {
      inherit pkgs;
      inherit (pkgs) system;
    };
}
