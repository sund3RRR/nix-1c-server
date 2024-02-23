{ config
, lib
, pkgs
, ... }:

let
  serverInstanceType = lib.types.submodule {
    options.enable = lib.mkEnableOption (lib.mdDoc "this instance");

    options.version = lib.mkOption {
      default = "";
      description = "Version of 1C server instance";
      type = lib.types.str;
    };

    options.ibcmd = lib.mkOption {
      default = {};
      description = "Console server management utility";
      type = lib.types.submodule {
        options.enable = lib.mkEnableOption (lib.mdDoc "ibcmd");
      };
    };

    options.ibsrv = lib.mkOption {
      default = {};
      description = "Server entrypoint program";
      type = lib.types.submodule {
        options.enable = lib.mkEnableOption (lib.mdDoc "ibsrv");
      };
    };

    options.services = lib.mkOption {
      default = {};
      description = "Instance services configuration";
      type = lib.types.submodule {
        options.full-server = lib.mkOption {
          default = {};
          description = "Main server service";
          type = lib.types.submodule {
            options.enable = lib.mkEnableOption (lib.mdDoc "main server service");
            options.openFirewall = lib.mkOption {
              default = false;
              description = "Whether to open ports in firewall";
              type = lib.types.bool;
            };
            options.settings = lib.mkOption {
              default = {};
              description = "Settings for main server service";
              type = lib.types.submodule {
                options.port = lib.mkOption {
                  default = 1540;
                  description = "Cluster agent main port";
                  type = lib.types.port;
                };
                options.regPort = lib.mkOption {
                  default = 1541;
                  description = "Cluster main port for default cluster";
                  type = lib.types.port;
                };
                options.portRange = lib.mkOption {
                  default = "1560:1591";
                  description = "Port range for connection pool";
                  type = lib.types.str;
                };
                options.debug = lib.mkOption {
                  default = "";
                  description = ''
                      1C:Enterprise server configuration debug mode
                      DEBUG off: empty (default)
                      TCP    on: -debug or "-debug -tcp"
                      HTTP   on: "-debug -http"
                  '';
                  type = lib.types.str;
                };
                options.data = lib.mkOption {
                  default = "/var/lib/usr1cv8/.1cv8/1C/1cv8";
                  description = "Path to directory with cluster data";
                  type = lib.types.str; 
                };
                options.securityLevel = lib.mkOption {
                  default = 0;
                  description = ''
                      0 - default - unprotected connections
                      1 - protected connections only for the time of user authentication
                      2 - permanently protected connections
                  '';
                  type = lib.types.int;
                };
                options.pingPeriod = lib.mkOption {
                  default = 1000;
                  description = "Check period for connection loss detector, milliseconds";
                  type = lib.types.int;
                };
                options.pingTimeout = lib.mkOption {
                  default = 5000;
                  description = "Response timeout for connection loss detector, milliseconds";
                  type = lib.types.int;
                };
                options.extraArgs = lib.mkOption {
                  default = [];
                  description = "Extra command line arguments for server";
                  type = lib.types.listOf lib.types.str;
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
          description = "Standalone server service";
          type = lib.types.submodule {
            options.enable = lib.mkEnableOption (lib.mdDoc "standalone server");
            options.openFirewall = lib.mkOption {
              default = false;
              description = "Whether to open ports in firewall";
              type = lib.types.bool;
            };
            options.settings = lib.mkOption {
              default = {};
              description = "Standalone server settings";
              type = lib.types.submodule {
                options.http = lib.mkOption {
                  default = {};
                  description = "HTTP settings";
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
                  };
                };
                options.data = lib.mkOption {
                  type = lib.types.str;
                  description = "Path to the server data directory.";
                  default = "/var/lib/usr1cv8/.1cv8/1C/1cv8/standalone-server/";
                };
                options.name = lib.mkOption {
                  default = "";
                  description = ''
                    Infobase name.
                    By default, an infobase ID string presentation is used
                  '';
                  type = lib.types.str;
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
                options.debug-port = lib.mkOption {
                  type = lib.types.port;
                  description = "TCP port used by the debug server over HTTP";
                  default = 1550;
                };
                options.extraArgs = lib.mkOption {
                  default = [];
                  description = "Extra command line arguments for server";
                  type = lib.types.listOf lib.types.str;
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
      default = "";
      description = "Directory with 1C source .deb packages";
      type = lib.types.either lib.types.path lib.types.str;
    };
    instances = lib.mkOption {
      default = {};
      description = "Attribute set of instances. Key is the instance label, value is the settings.";
      type = lib.types.attrsOf serverInstanceType;
    };
  };
}
