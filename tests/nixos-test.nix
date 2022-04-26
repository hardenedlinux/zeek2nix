{
  makeTest ? import (pkgs.path + "/nixos/tests/make-test-python.nix"),
  pkgs,
  inputs,
  ...
}: {
  zeek-standalone-vm-systemd =
    makeTest {
      name = "zeek-standalone-vm-systemd";
      machine = {...}:
        {virtualisation.memorySize = 2046;}
        // import ./standalone.nix {inherit pkgs inputs;};
      testScript = ''
        start_all()
        machine.wait_for_unit("network.target")
        machine.wait_for_unit("zeek.service")
        machine.sleep(5)
        print(machine.succeed("zeekctl status"))
        print(machine.succeed("ls -il /var/lib/zeek/zeek-spicy/modules"))
        machine.sleep(5)
        # for privateScripts
        machine.wait_for_file("/var/lib/zeek/spool/zeek/loaded_scripts.log")
        print(machine.succeed("cat /var/lib/zeek/spool/zeek/loaded_scripts.log | grep 'zeek-query.zeek\|http_remove.zeek'"))
      '';
    } {
      inherit pkgs;
      inherit (pkgs) system;
    };
  zeek-cluster-vm-systemd =
    makeTest {
      name = "zeek-cluster-vm-systemd";
      nodes = {
        machine = {...}:
          {
            virtualisation = {
              memorySize = 4046;
              cores = 2;
            };
          }
          // import ./cluster.nix {inherit pkgs inputs;};
        sensor = {...}:
          {
            virtualisation = {
              memorySize = 4046;
              cores = 2;
            };
          }
          // import ./sensor.nix {inherit pkgs inputs;};
      };
      testScript = {nodes, ...}: ''
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
    } {
      inherit pkgs;
      inherit (pkgs) system;
    };
}
