{ config
, lib
, pkgs
, ... }:

{
  imports = [ ./modules/options.nix ];

  config = lib.mkMerge [
    { users.groups.grp1cv8 = {}; }
    {
      users.users = lib.concatMapAttrs (k: v: {
        "usr1cv8-${k}" = {
          group = "grp1cv8";
          extraGroups = [ ];
          home = "/var/lib/usr1cv8-${k}";
          isSystemUser = true;
          createHome = true;
        };
      }) config.server-1c.instances;

      
      systemd.services = lib.concatMapAttrs (k: v:
        let
          server-1c = pkgs.callPackage ./pkgs/1c-server {
            version = v.version;
            sourceDir = config.server-1c.sourceDir;
        };
        in
        {
        "1c-server-${v.version}-${k}.service" = lib.mkIf v.services.full-server.enable {
          description = "1C:Enterprise Server 8.3 (${v.version})";
          after = [ "network.target" ];
          wantedBy = [ "multi-user.target" ];

          serviceConfig = 
          let
            cfg = v.services.full-server;
            commandLineArgsServer = [
              "-d ${cfg.settings.data}"
              "-port ${builtins.toString cfg.settings.port}"
              "-regport ${builtins.toString cfg.settings.regPort}"
              "-range ${cfg.settings.portRange}"
              "-seclev ${builtins.toString cfg.settings.securityLevel}"
              "-pingPeriod ${builtins.toString cfg.settings.pingPeriod}"
              "-pingTimeout ${builtins.toString cfg.settings.pingTimeout}"
              "${cfg.settings.debug}"
            ];
            server-1c-fhs-wrapper = pkgs.callPackage ./pkgs/1c-server-fhs {
              argsServer = commandLineArgsServer;
              server-1c-pkg = server-1c;
            };
          in
          {
            ExecStart = "${server-1c-fhs-wrapper}/bin/1c-server-fhs --full-server";
            Restart = "always";
            User = "usr1cv8-${k}";
            Group = "grp1cv8";
            WorkingDirectory = "/var/lib/usr1cv8-${k}";
            Type = "simple"; 
          };
        };
        "1c-standalone-server-${v.version}-${k}" = lib.mkIf v.services.standalone-server.enable {
          description = "1C:Enterprise Standalone Server 8.3 (${v.version})";
          after = [ "network.target" ];
          wantedBy = [ "multi-user.target" ];

          serviceConfig = 
          let
            cfg = v.services.standalone-server;
            commandLineArgsStandalone = [
              (if cfg.settings.http.enable then "--enable-http-gate" else "--disable-http-gate")
              "--http-port=${builtins.toString cfg.settings.http.port}"

              (if (cfg.settings.name == "") then "" else "--name=${cfg.settings.name}")

              "--data=${cfg.settings.data}"
              "--direct-regport=${builtins.toString cfg.settings.direct-regport}"
              "--direct-range=${cfg.settings.direct-range}"

              "--debug-port=${builtins.toString cfg.settings.debug-port}"
            ];
            server-1c-fhs-wrapper = pkgs.callPackage ./pkgs/1c-server-fhs {
              argsStandalone = commandLineArgsStandalone;
              server-1c-pkg = server-1c;
            };
          in
          {
            ExecStart = "${server-1c-fhs-wrapper}/bin/1c-server-fhs --standalone-server";
            Restart = "always";
            User = "usr1cv8-${k}";
            Group = "grp1cv8";
            WorkingDirectory = "/var/lib/usr1cv8-${k}";
            Type = "simple";
          };
        };
      }
      ) config.server-1c.instances;
    }
  ];
}
