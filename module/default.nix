{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.zeek;
  zeek-oneshot = pkgs.writeScript "zeek-oneshot" ''
    ${cfg.package}/bin/zeekctl deploy
    if [ $? -eq 0 ]; then
    sleep infinity
    else
    exit
    fi
  '';
  standaloneConfig = ''
    [zeek]
    type=standalone
    host=${cfg.listenAddress}
    interface=${cfg.interface}
  '';

  ClusterConfig = ''
    [logger]
    type=logger
    host=localhost
    [manager]
    type=manager
    host=localhost

    [proxy-1]
    type=proxy
    host=localhost

    [worker-1]
    type=worker
    host=localhost
    interface=eth0

    [worker-2]
    type=worker
    host=localhost
    interface=eth0
  '';

  nodeConf = pkgs.writeText "node.cfg" (if cfg.standalone then standaloneConfig else cfg.extraConfig);
  networkConf = pkgs.writeText "networks.cfg" cfg.network;

  preRun = pkgs.writeScript "run-zeekctl" ''
     if [[ ! -d "/var/lib/zeek" ]];then
         mkdir -p /var/lib/zeek/policy \
             /var/lib/zeek/spool \
             /var/lib/zeek/logs \
             /var/lib/zeek/scripts\
             /var/lib/zeek/etc
         cp -r ${cfg.package}/share/zeekctl/scripts/* /var/lib/zeek/scripts/
     fi
     ln -sf ${nodeConf} /var/lib/zeek/etc/node.cfg
     ln -sf ${networkConf} /var/lib/zeek/etc/networks.cfg
    ${optionalString (cfg.privateScript != null)
      "echo \"${cfg.privateScript}\" >> ${cfg.dataDir}/policy/local.zeek"
     }
  '';
in
{

  options.services.zeek = {
    enable = mkOption {
      description = "Whether to enable zeek.";
      default = false;
      type = types.bool;
    };

    dataDir = mkOption {
      type = types.path;
      default = "/var/lib/zeek";
      description = ''
        Data directory for zeek. Do not change
      '';
    };

    package = mkOption {
      description = "Zeek package to use.";
      default = pkgs.zeek-release;
      defaultText = "pkgs.zeek";
      type = types.package;
    };

    standalone = mkOption {
      description = "Whether to enable zeek Standalone mode";
      default = false;
      type = types.bool;
    };

    interface = mkOption {
      description = "Zeek listen address.";
      default = "eth0";
      type = types.str;
    };

    listenAddress = mkOption {
      description = "Zeek listen address.";
      default = "localhost";
      type = types.str;
    };

    network = mkOption {
      description = "Zeek network configuration.";
      default = ''
        # List of local networks in CIDR notation, optionally followed by a
        # descriptive tag.
        # For example, "10.0.0.0/8" or "fe80::/64" are valid prefixes.

        10.0.0.0/8          Private IP space
        172.16.0.0/12       Private IP space
        192.168.0.0/16      Private IP space
      '';
      type = types.lines;
    };

    privateScript = mkOption {
      description = "Zeek load private script path";
      default = "";
      type = types.str;
    };

    extraConfig = mkOption {
      type = types.lines;
      default = ClusterConfig;
      description = "Zeek cluster configuration.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    systemd.services.zeek = {
      description = "Zeek Daemon";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      path = [ cfg.package pkgs.gawk pkgs.gzip ];
      preStart = ''
        ${pkgs.bash}/bin/bash ${preRun}
      '';
      serviceConfig = {
        ExecStart = ''
          ${pkgs.bash}/bin/bash ${zeek-oneshot}
        '';
        ExecStop = "${cfg.package}/bin/zeekctl stop";
        User = "root";
        PrivateTmp = "yes";
        PrivateDevices = "yes";
        RuntimeDirectory = "zeek";
        RuntimeDirectoryMode = "0755";
        LimitNOFILE = "30000";
      };
    };
  };
}
