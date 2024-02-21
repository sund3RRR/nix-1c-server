{ pkgs
, lib
, buildFHSEnv
, argsServer ? []
, argsStandalone ? []
, server-1c-pkg
}:

buildFHSEnv {
    name = "1c-server-fhs";
    targetPkgs = pkgs: [ pkgs.corefonts pkgs.fontconfig ];

    runScript = pkgs.writeShellScript "1c-server-wrapper.sh" ''
      case $1 in
        "--full-server")
          ${server-1c-pkg}/opt/1cv8/x86_64/${server-1c-pkg.version}/ragent \
            ${ lib.concatStringsSep " " argsServer }
        ;;
        "--standalone-server")
          ${server-1c-pkg}/opt/1cv8/x86_64/${server-1c-pkg.version}/ibsrv \
            ${ lib.concatStringsSep " " argsStandalone }
        ;;
        "--ibcmd")
          shift
          exec ${server-1c-pkg}/opt/1cv8/x86_64/${server-1c-pkg.version}/ibcmd "$@"
        ;;
        "--ibsrv")
          shift
          exec ${server-1c-pkg}/opt/1cv8/x86_64/${server-1c-pkg.version}/ibsrv "$@"
        ;;
        *)
          echo "Wrong argument. Valid values: --full-server, --standalone-server, --ibcmd, --ibsrv"
          exit 1
        ;;
      esac
    '';
}
