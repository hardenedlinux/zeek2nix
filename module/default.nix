{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.zeek;

  standaloneConfig = ''
    [zeek]
    type=standalone
    host=${cfg.host}
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
    host=<remotehost>
    interface=eth0
  '';

  nodeConf = pkgs.writeText "node.cfg" (if cfg.node == null then standaloneConfig else cfg.node);
  networkConf = pkgs.writeText "networks.cfg" cfg.network;
in
{

  options.services.zeek = {
    enable = mkOption {
      description = "Whether to enable zeek.";
      default = false;
      type = types.bool;
    };

    sensor = mkOption {
      description = "Whether to enable zeek sensor mode.";
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

    host = mkOption {
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
      default = null;
      type = types.nullOr types.str;
    };

    node = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Zeek cluster configuration.";
    };
  };

  config = mkIf cfg.enable {
    systemd.services.zeek = {
      description = "Zeek Daemon";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      path = with pkgs;
        [ "/run/current-system/sw" cfg.package nettools nettools iputils coreutils ];

      script = ''
        if [[ ! -d "${cfg.dataDir}/logs/current" ]];then
        mkdir -p ${cfg.dataDir}/{policy,spool,logs,scripts,etc}
        fi
        for file in ${cfg.package}/share/zeekctl/scripts/*; do
        cp -rf $file ${cfg.dataDir}/scripts/.
        done
        ${pkgs.coreutils}/bin/ln -sf ${nodeConf} ${cfg.dataDir}/etc/node.cfg
        ${pkgs.coreutils}/bin/ln -sf ${networkConf} ${cfg.dataDir}/etc/networks.cfg
        ${cfg.package}/bin/zeekctl install
        ${optionalString (cfg.privateScript != null)
          "echo \"${cfg.privateScript}\" >> ${cfg.dataDir}/policy/local.zeek"
         }
        ${optionalString (cfg.sensor != true)''
          ${cfg.package}/bin/zeekctl deploy
         ''}
      '';

      serviceConfig = {
        Type = "oneshot";
        User = "root";
        RemainAfterExit = true;
        restartTriggers = [
          cfg.node
          cfg.network
        ];
        restartIfChanged = true;
      };
    };
  };
}
