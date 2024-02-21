{ config
, lib
, pkgs
, ... }:

let
  serverInstanceType = lib.types.submodule {
    options.enable = lib.mkEnableOption (lib.mdDoc "ibcmd");

    options.version = lib.mkOption {
      description = "Version of 1C server instance";
      type = lib.types.str;
      default = "";
    };

    options.ibcmd = lib.mkOption {
      type = lib.types.submodule {
        options.enable = lib.mkEnableOption (lib.mdDoc "ibcmd");
      };
    };
    options.full-server = lib.mkOption {
      default = {};
      type = lib.types.submodule {
        options.enable = lib.mkEnableOption (lib.mdDoc "ibcmd");
        options.settings = lib.mkOption {
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
            # options.keytabFile = lib.mkOption {
            #   type = lib.types.path;
            #   description = "1C:Enterprise server keytab file";
            #   default = server-1c + /opt/1cv8/x86_64/${server-1c.version}/usr1cv8.keytab;
            # };
          };
        };
      };
    };
    options.standalone-server = lib.mkOption {
      default = {};
      type = lib.types.submodule {
        options.enable = lib.mkEnableOption (lib.mdDoc "ibcmd");
        options.settings = lib.mkOption {
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
    };
  };
in
{
  options.server-1c = {
    sourceDir = lib.mkOption {
      type = lib.types.either lib.types.path lib.types.str;
      description = "Directory with 1C source .deb packages";
      default = "";
    };
    instances = lib.mkOption {
      description = "";
      type = lib.types.attrsOf serverInstanceType;
      default = {};
    };
  };


  config = lib.mkMerge [
    (lib.mkIf (lib.length (lib.attrNames config.server-1c.instances) > 0) {
      users.users.usr1cv8 = {
        group = "grp1cv8";
        extraGroups = [ ];
        home = "/var/lib/usr1cv8";
        isSystemUser = true;
        createHome = true;
      };
      users.groups.grp1cv8 = {};
    })
    {
      systemd.services = lib.concatMapAttrs (k: v:
        let
          server-1c = pkgs.callPackage ./pkgs/1c-server {
            version = v.version;
            sourceDir = config.server-1c.sourceDir;
        };
        in
        {
        "1c-server-${v.version}-${k}.service" = lib.mkIf v.full-server.enable {
          description = "1C:Enterprise Server 8.3 (${v.version})";
          after = [ "network.target" ];
          wantedBy = [ "multi-user.target" ];

          serviceConfig = 
          let
            commandLineArgsServer = [
              "-d ${v.full-server.settings.data}"
              "-port ${builtins.toString v.full-server.settings.port}"
              "-regport ${builtins.toString v.full-server.settings.regPort}"
              "-range ${v.full-server.settings.portRange}"
              "-seclev ${builtins.toString v.full-server.settings.securityLevel}"
              "-pingPeriod ${builtins.toString v.full-server.settings.pingPeriod}"
              "-pingTimeout ${builtins.toString v.full-server.settings.pingTimeout}"
              "${v.full-server.settings.debug}"
            ];
            server-1c-fhs-wrapper = pkgs.callPackage ./pkgs/1c-server-fhs {
              argsServer = commandLineArgsServer;
              server-1c-pkg = server-1c;
            };
          in
          {
            ExecStart = "${server-1c-fhs-wrapper}/bin/1c-server-fhs --full-server";
            Restart = "always";
            User = "usr1cv8";
            Group = "grp1cv8";
            WorkingDirectory = "/var/lib/usr1cv8";
            Type = "simple"; 
          };
        };
        "1c-standalone-server-${v.version}-${k}" = lib.mkIf v.standalone-server.enable {
          description = "1C:Enterprise Standalone Server 8.3 (${v.version})";
          after = [ "network.target" ];
          wantedBy = [ "multi-user.target" ];

          serviceConfig = 
          let
            scfg = v.standalone-server;
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
            server-1c-fhs-wrapper = pkgs.callPackage ./pkgs/1c-server-fhs {
              argsStandalone = commandLineArgsStandalone;
              server-1c-pkg = server-1c;
            };
          in
          {
            ExecStart = "${server-1c-fhs-wrapper}/bin/1c-server-fhs --standalone-server";
            Restart = "always";
            User = "usr1cv8";
            Group = "grp1cv8";
            WorkingDirectory = "/var/lib/usr1cv8";
            Type = "simple"; 
          };
        };
      }
      ) config.server-1c.instances;
    }
  ];
}
