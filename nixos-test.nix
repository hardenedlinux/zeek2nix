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
        ];

        virtualisation.memorySize = 2046;

        services.zeek = {
          enable = true;
          standalone = true;
          interface = "eth0";
          host = "127.0.0.1";
          package = self.packages."${pkgs.system}".zeek-release.override { };
        };
      };
      testScript = ''
        start_all()
        machine.wait_for_unit("network.target")
        machine.wait_for_unit("zeek.service")
        machine.sleep(5)
        print(machine.succeed("ls -il /var/lib/zeek"))
        print(machine.succeed("zeekctl status"))
      '';
    }
    {
      inherit pkgs;
      inherit (pkgs) system;
    };

  zeek-cluster-vm-systemd = makeTest
    {
      name = "zeek-cluster-vm-systemd";
      machine = { config, pkgs, ... }: {
        imports = [
          self.nixosModules.zeek
        ];

        environment.systemPackages = [
          self.packages."${pkgs.system}".zeek-release
        ];

        virtualisation.memorySize = 4046;

        # proxy login
        services.zeek = rec {
          enable = true;
          interface = "eth0";
          host = "localhost";
          node = ''
            [logger]
            type=logger
            host=127.0.0.1

            [manager]
            type=manager
            host=127.0.0.1

            [proxy-1]
            type=proxy
            host=127.0.0.1

            [worker-1]
            type=worker
            host=127.0.0.1
            interface=${interface}
          '';
          package = self.packages."${pkgs.system}".zeek-release.override { };
        };
      };
      testScript = ''
        start_all()
        machine.wait_for_unit("network.target")
        machine.wait_for_unit("zeek.service")
        machine.sleep(5)
        print(machine.succeed("ls -il /var/lib/zeek"))
        #Do not check on github action
        #broker default port
        machine.wait_for_open_port(47761)
        print(machine.succeed("zeekctl status"))
      '';
    }
    {
      inherit pkgs;
      inherit (pkgs) system;
    };
}
