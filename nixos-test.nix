{ makeTest, pkgs, self }:
{
  zeek-vm-systemd = makeTest
    {
      name = "zeek-vm-systemd";
      machine = { config, pkgs, ... }: {
        imports = [
          self.nixosModules.zeek
        ];

        virtualisation.memorySize = 2046;

        services.zeek = {
          enable = true;
          standalone = true;
          interface = "eth0";
          listenAddress = "localhost";
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
        #print(machine.succeed("ls -il /var/lib/zeek/logs/current"))
      '';
    }
    {
      inherit pkgs;
      inherit (pkgs) system;
    };
}
