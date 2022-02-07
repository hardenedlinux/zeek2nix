{ config
, lib
, pkgs
, ...
}:
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
  nodeConf = pkgs.writeText "node.cfg" (
    if cfg.node == null
    then standaloneConfig
    else cfg.node
  );
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
    privateScripts = mkOption {
      description = "Zeek load private script path";
      default = null;
      type = types.nullOr types.lines;
    };
    privateSpicyScripts = mkOption {
      description = "Zeek load private Spicy *.htl";
      default = [ ];
    };
    node = mkOption {
      type = types.nullOr types.lines;
      default = null;
      description = "Zeek cluster configuration.";
    };
  };
  config = mkIf cfg.enable {
    security.wrappers = {
      zeek = {
        source = "${cfg.package}/bin/zeek";
        capabilities = "cap_net_raw,cap_net_admin+eip";
        owner = "zeek";
        group = "zeek";
      };
      zeekctl = {
        source = "${cfg.package}/bin/zeekctl";
        capabilities = "cap_net_raw,cap_net_admin+eip";
        owner = "zeek";
        group = "zeek";
      };
    };
    users.users.zeek = {
      isSystemUser = true;
      group = "zeek";
    };
    users.groups.zeek = { };
    systemd.services.zeek = {
      description = "Zeek Daemon";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      path =
        with pkgs;
        [
          "/run/current-system/sw"
          "/run/wrappers/bin/"
          nettools
          nettools
          iputils
          coreutils
        ];
      script = ''
        if [[ ! -d "${cfg.dataDir}/logs/current" ]];then
        mkdir -p ${cfg.dataDir}/{policy,spool,logs,scripts,etc,zeek-spicy/modules}
        fi
        for file in ${cfg.package}/share/zeekctl/scripts/*; do
        cp -rf $file ${cfg.dataDir}/scripts/.
        done
        chmod -R +rw ${cfg.dataDir}/scripts/{helpers,postprocessors}
        cp -rf ${nodeConf} ${cfg.dataDir}/etc/node.cfg
        cp -rf ${networkConf} ${cfg.dataDir}/etc/networks.cfg

        ${
        optionalString (cfg.privateScripts != null) "echo \"${cfg.privateScripts}\" >> ${cfg.dataDir}/policy/local.zeek"
      }
        ${
        optionalString (cfg.privateSpicyScripts != [ ]) "${
          lib.concatStringsSep "\n" (
            map (f: "cp -rf ${f} ${cfg.dataDir}/zeek-spicy/modules")
            cfg.privateSpicyScripts
          )
        }"
      }

        ${
        optionalString cfg.sensor ''
          /run/wrappers/bin/zeekctl install
        ''
      }
        ${
        optionalString (!cfg.sensor) ''
          /run/wrappers/bin/zeekctl deploy
        ''
      }
      '';
      serviceConfig = {
        Type = "oneshot";
        User =
          if cfg.standalone
          then "zeek"
          else "root";
        Group =
          if cfg.standalone
          then "zeek"
          else "root";
        ExecReload = "/run/wrappers/bin/zeekctl restart";
        ExecStop = "/run/wrappers/bin/zeekctl stop";
        WorkingDirectory = "${cfg.dataDir}";
        ReadWritePaths = "${cfg.dataDir}";
        RuntimeDirectory = "zeek";
        CacheDirectory = "zeek";
        StateDirectory = "zeek";
        RemainAfterExit = true;
        restartTriggers = [ networkConf nodeConf ];
        restartIfChanged = true;
      };
    };
  };
}
