{ config
, lib
, pkgs
, ... }:

{
  imports = [ ./modules/options.nix ];

  config = lib.mkMerge [
    (lib.mkIf (lib.length (lib.attrNames config.server-1c.instances) > 0) { 
      users.groups.grp1cv8 = {};
      users.users.usr1cv8 = {
        group = "grp1cv8";
        extraGroups = [ ];
        home = "/var/lib/usr1cv8";
        isSystemUser = true;
        createHome = true;
      };
    })
    {
      environment.systemPackages = lib.concatLists (lib.mapAttrsToList (k: v:
      let
        server-1c = pkgs.callPackage ./pkgs/1c-server {
          version = v.version;
          sourceDir = config.server-1c.sourceDir;
        };
        server-1c-fhs-wrapper = pkgs.callPackage ./pkgs/1c-server-fhs {
          server-1c-pkg = server-1c;
        };
      in
        (if v.programs.ibcmd.enable then [
          (pkgs.writeScriptBin "ibcmd-${v.version}" "exec ${server-1c-fhs-wrapper}/bin/1c-server-fhs --ibcmd \"$@\"")
        ] else []) ++
        (if v.programs.ibsrv.enable then [
          (pkgs.writeScriptBin "ibsrv-${v.version}" "exec ${server-1c-fhs-wrapper}/bin/1c-server-fhs --ibsrv \"$@\"")
        ] else [])
      ) config.server-1c.instances);
    }
    {
      networking.firewall.allowedTCPPorts = lib.concatLists (lib.mapAttrsToList (k: v:
        (if v.services.full-server.openFirewall then
          [
            v.services.full-server.settings.port
            v.services.full-server.settings.regPort
          ] else []) ++
        (if v.services.standalone-server.openFirewall then
          [
            (lib.mkIf v.services.standalone-server.settings.http.enable v.services.standalone-server.settings.http.port)
            v.services.standalone-server.settings.direct-regport
            v.services.standalone-server.settings.debug-port
        ] else [])) config.server-1c.instances);

      networking.firewall.allowedTCPPortRanges = lib.concatLists (lib.mapAttrsToList (k: v:
      let
        main-port-range = lib.splitString ":" v.services.full-server.settings.portRange;
        standalone-port-range = lib.splitString ":" v.services.standalone-server.settings.direct-range;
      in
        (if v.services.full-server.openFirewall then 
        [{
          from = lib.strings.toInt (builtins.elemAt main-port-range 0);
          to = lib.strings.toInt (builtins.elemAt main-port-range 1);
        }] else []) ++
        (if v.services.standalone-server.openFirewall then 
        [{
          from = lib.strings.toInt (builtins.elemAt standalone-port-range 0);
          to = lib.strings.toInt (builtins.elemAt standalone-port-range 1);
        }] else [])) config.server-1c.instances);

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
          preStart = ''
            chown -R "usr1cv8:grp1cv8" "${v.services.full-server.settings.data}"
          '';
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
            ] ++ cfg.settings.extraArgs;
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
            PermissionsStartOnly = true;
          };
        };
        "1c-standalone-server-${v.version}-${k}" = lib.mkIf v.services.standalone-server.enable {
          description = "1C:Enterprise Standalone Server 8.3 (${v.version})";
          after = [ "network.target" ];
          wantedBy = [ "multi-user.target" ];
          preStart = ''
            chown -R "usr1cv8:grp1cv8" "${v.services.standalone-server.settings.data}"
          '';
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
            ] ++ cfg.settings.extraArgs;
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
            PermissionsStartOnly = true;
          };
        };
      }
      ) config.server-1c.instances;
    }
  ];
}
