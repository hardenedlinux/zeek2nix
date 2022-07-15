{
  config,
  lib,
  pkgs,
  packages,
  ...
}: {
  networking.hostName = "zeek-dev";

  users.users.root.password = "";

  services.openssh = {
    enable = true;
    permitRootLogin = "yes";
  };

  services.zeek = {
    enable = true;
    standalone = true;
    interface = "eth0";
    host = "127.0.0.1";
    package = packages.zeek-latest.override {};
  };
}
