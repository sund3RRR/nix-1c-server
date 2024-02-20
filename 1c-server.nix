{ config
, lib
, pkgs
, ... }:

let
  server-1c = pkgs.callPackage ../pkgs/1c-server { };

  server-1c-fhs-wrapper = pkgs.buildFHSEnv {
    name = "1c-server-fhs";
    targetPkgs = pkgs: [ pkgs.corefonts pkgs.fontconfig ];

    runScript = pkgs.writeShellScript "1c-server-wrapper.sh" ''
      case $1 in
        "--full-server")
          ${server-1c}/opt/1cv8/x86_64/${server-1c.version}/ragent \
            ${ lib.concatStringsSep " " commandLineArgsServer }
        ;;
        "--standalone-server")
          ${server-1c}/opt/1cv8/x86_64/${server-1c.version}/ibsrv \
            ${ lib.concatStringsSep " " commandLineArgsStandalone }
        ;;
        "--ibcmd")
          shift
          exec ${server-1c}/opt/1cv8/x86_64/${server-1c.version}/ibcmd "$@"
        ;;
        "--ibsrv")
          shift
          exec ${server-1c}/opt/1cv8/x86_64/${server-1c.version}/ibsrv "$@"
        ;;
        *)
          echo "Wrong argument. Valid values: --full-server, --standalone-server, --ibcmd, --ibsrv"
          exit 1
        ;;
      esac
    '';
  };

  commandLineArgsServer = [
    "-d ${config.services.server-1c.settings.data}"
    "-port ${builtins.toString config.services.server-1c.settings.port}"
    "-regport ${builtins.toString config.services.server-1c.settings.regPort}"
    "-range ${config.services.server-1c.settings.portRange}"
    "-seclev ${builtins.toString config.services.server-1c.settings.securityLevel}"
    "-pingPeriod ${builtins.toString config.services.server-1c.settings.pingPeriod}"
    "-pingTimeout ${builtins.toString config.services.server-1c.settings.pingTimeout}"
    "${config.services.server-1c.settings.debug}"
  ];

  scfg = config.services.standalone-server-1c;

  commandLineArgsStandalone = [
    (if scfg.settings.http.enable then "--enable-http-gate" else "--disable-http-gate")
    "--http-address=${builtins.toString scfg.settings.http.address}"
    "--http-port=${builtins.toString scfg.settings.http.port}"
    "--http-base=${scfg.settings.http.base}"

    (if (scfg.settings.name == "") then "" else "--name=${scfg.settings.name}")

    "--data=${scfg.settings.data}"
    "--distribute-licenses=${scfg.settings.distribute-licenses}"
    "--schedule-jobs=${scfg.settings.schedule-jobs}"
    "--disable-local-speech-to-text=${scfg.settings.disable-local-speech-to-text}"
    "--direct-regport=${builtins.toString scfg.settings.direct-regport}"
    "--direct-range=${scfg.settings.direct-range}"
    "--direct-seclevel=${builtins.toString scfg.settings.direct-seclevel}"

    (if scfg.settings.enable-extended-designer-features
      then "--enable-extended-designer-features"
      else "--disable-extended-designer-features")

    (if scfg.settings.enable-direct-gate then "--enable-direct-gate" else "--disable-direct-gate")

    "--debug=${scfg.settings.debug.type}"
    "--debug-address=${scfg.settings.debug.address}"
    "--debug-port=${builtins.toString scfg.settings.debug.port}"
  ];
in 
{
  options.services.server-1c = {
    enable = lib.mkEnableOption (lib.mdDoc "1cv8");
    settings = lib.mkOption {
      default = {};
      type = lib.types.submodule {
        options.port = lib.mkOption {
          type = lib.types.port;
          description = "Cluster agent main port";
          default = 1540;
        };
        options.regPort = lib.mkOption {
          type = lib.types.port;
          description = "Cluster main port for default cluster";
          default = 1541;
        };
        options.portRange = lib.mkOption {
          type = lib.types.str;
          description = "Port range for connection pool";
          default = "1560:1591";
        };
        options.debug = lib.mkOption {
          type = lib.types.str;
          description = ''
            1C:Enterprise server configuration debug mode
            DEBUG off: empty (default)
            TCP    on: -debug or "-debug -tcp"
            HTTP   on: "-debug -http"
          '';
          default = "";
        };
        options.data = lib.mkOption {
          type = lib.types.str;
          description = "Path to directory with cluster data";
          default = "/var/lib/usr1cv8/.1cv8/1C/1cv8";
        };
        options.securityLevel = lib.mkOption {
          type = lib.types.int;
          description = ''
            0 - default - unprotected connections
            1 - protected connections only for the time of user authentication
            2 - permanently protected connections
          '';
          default = 0;
        };
        options.pingPeriod = lib.mkOption {
          type = lib.types.int;
          description = "Check period for connection loss detector, milliseconds";
          default = 1000;
        };
        options.pingTimeout = lib.mkOption {
          type = lib.types.int;
          description = "Response timeout for connection loss detector, milliseconds";
          default = 5000;
        };
        options.keytabFile = lib.mkOption {
          type = lib.types.path;
          description = "1C:Enterprise server keytab file";
          default = server-1c + /opt/1cv8/x86_64/${server-1c.version}/usr1cv8.keytab;
        };
      };
    };
  }; 

  options.services.standalone-server-1c = {
    enable = lib.mkEnableOption (lib.mdDoc "ibsrv");
    settings = lib.mkOption {
      default = {};
      type = lib.types.submodule {
        options.http = lib.mkOption {
          default = {};
          type = lib.types.submodule {
            options.enable = lib.mkOption {
              type = lib.types.bool;
              description = "Prohibit access to the standalone server via HTTP";
              default = true;
            };
            options.port = lib.mkOption {
              type = lib.types.port;
              description = "Main TCP port used by the server.";
              default = 8314;
            };
            options.address = lib.mkOption {
              type = lib.types.str;
              description = ''
                The main IP address used by the server.
                Possible values:
                  localhost - local network interface.
                  any - all available network interfaces.
                  xxx.xxx.xxx.xxx - IPv4 address of a network interface.
                  xxxx:xxxx:xxxx:xxxx:xxxx:xxxx:xxxx:xxxx - IPv6 address of a network interface.
              '';
              default = "localhost";
            };
            options.base = lib.mkOption {
              type = lib.types.str;
              description = "Base path to publish infobases";
              default = "/";
            };
          };
        };
        options.data = lib.mkOption {
          type = lib.types.str;
          description = "Path to the server data directory.";
          default = "/var/lib/usr1cv8/.1cv8/1C/1cv8/standalone-server/";
        };
        options.name = lib.mkOption {
          type = lib.types.str;
          description = ''
            Infobase name.
            By default, an infobase ID string presentation is used
          '';
          default = "";
        };
        options.distribute-licenses = lib.mkOption {
          type = lib.types.str;
          description = ''
            Shows whether client license issue is allowed.
            Possible values:
              allow (yes, true). Client license issue is allowed.
              deny (no, false). Client license issue is denied.
          '';
          default = "allow";
        };
        options.schedule-jobs = lib.mkOption {
          type = lib.types.str;
          description = ''
            Shows whether scheduled job planning is allowed.
            Possible values:
              allow (yes, true). Scheduled job planning is allowed.
              deny (no, false). Scheduled job planning is denied.
          '';
          default = "allow";
        };
        options.disable-local-speech-to-text = lib.mkOption {
          type = lib.types.str;
          description = ''
            Deny local speech recognition.
            Possible values:
              yes (true, deny): denied.
              no (false, allow): allowed.
          '';
          default = "yes";
        };
        options.direct-regport = lib.mkOption {
          type = lib.types.port;
          description = "Primary port used to establish direct server connection";
          default = 1541;
        };
        options.direct-range = lib.mkOption {
          type = lib.types.str;
          description = "Port range used to establish direct server connection";
          default = "1560:1591";
        };
        options.direct-seclevel = lib.mkOption {
          type = lib.types.int;
          description = "Security level of direct server connection <0|1|2>";
          default = 0;
        };
        options.enable-extended-designer-features = lib.mkOption {
          type = lib.types.bool;
          description = ''
            Enable advanced configuration options.
            Designer add-ins must be installed as a part of platform setup.
          '';
          default = false;
        };
        options.enable-direct-gate = lib.mkOption {
          type = lib.types.bool;
          description = "Permit direct access protocol to connect to the standalone server";
          default = true;
        };
        options.debug = lib.mkOption {
          default = {};
          type = lib.types.submodule {
            options.type = lib.mkOption {
              type = lib.types.str;
              description = "Enable infobase debug support <none|tcp|http|server>";
              default = "http";
            };
            options.port = lib.mkOption {
              type = lib.types.port;
              description = "TCP port used by the debug server over HTTP";
              default = 1550;
            };
            options.address = lib.mkOption {
              type = lib.types.str;
              description = ''
                IP address used by the debug server via HTTP.
                Possible values:
                  localhost - local network interface.
                  any - all available network interfaces.
                  xxx.xxx.xxx.xxx - IPv4 address of a network interface.
                  xxxx:xxxx:xxxx:xxxx:xxxx:xxxx:xxxx:xxxx - IPv6 address of a network interface.
              '';
              default = "127.0.0.1";
            };
          };
        };
      };
    };
  };
  options.programs.ibcmd = {
    enable = lib.mkEnableOption (lib.mdDoc "ibcmd");
  };

  options.programs.ibsrv = {
    enable = lib.mkEnableOption (lib.mdDoc "ibsrv");
  };

  config = lib.mkMerge [
    (lib.mkIf config.services.server-1c.enable {
      users.users.usr1cv8 = {
        group = "grp1cv8";
        extraGroups = [ ];
        home = "/var/lib/usr1cv8";
        isSystemUser = true;
        createHome = true;
      };
      users.groups.grp1cv8 = {};

      systemd.services.server-1c = {
        description = "1C:Enterprise Server 8.3 (${server-1c.version})";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];

        serviceConfig = {
          ExecStart = "${server-1c-fhs-wrapper}/bin/1c-server-fhs --full-server";
          Restart = "always";
          User = "usr1cv8";
          Group = "grp1cv8";
          WorkingDirectory = "/var/lib/usr1cv8";
          Type = "simple"; 
        };
      };

      networking.firewall = {
        allowedTCPPorts = [
          config.services.server-1c.port
          config.services.server-1c.regPort
        ];
        allowedUDPPorts = [
          config.services.server-1c.port
          config.services.server-1c.regPort
        ];
      };
    })
    (lib.mkIf config.services.standalone-server-1c.enable {
      users.users.usr1cv8 = {
        group = "grp1cv8";
        extraGroups = [ ];
        home = "/var/lib/usr1cv8";
        isSystemUser = true;
        createHome = true;
      };
      users.groups.grp1cv8 = {};

      systemd.services.standalone-server-1c = {
        description = "1C:Enterprise Standalone Server 8.3 (${server-1c.version})";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];

        serviceConfig = {
          ExecStart = "${server-1c-fhs-wrapper}/bin/1c-server-fhs --standalone-server";
          Restart = "always";
          User = "usr1cv8";
          Group = "grp1cv8";
          WorkingDirectory = "/var/lib/usr1cv8";
          Type = "simple"; 
        };
      };
    })
    (lib.mkIf config.programs.ibcmd.enable {
      environment.systemPackages = [
        (pkgs.writeScriptBin "ibcmd" "exec ${server-1c-fhs-wrapper}/bin/1c-server-fhs --ibcmd \"$@\"")
      ];
    })
    (lib.mkIf config.programs.ibsrv.enable {
      environment.systemPackages = [
        (pkgs.writeScriptBin "ibsrv" "exec ${server-1c-fhs-wrapper}/bin/1c-server-fhs --ibsrv \"$@\"")
      ];
    })
  ];
}
