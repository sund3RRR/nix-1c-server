{ config, pkgs, lib,... }:
let
  server-1c = builtins.fetchTarball {
    url = "https://github.com/sund3RRR/nix-1c-server/archive/412507cf4b58e3174ab17e4d78cb13bbdd046645.tar.gz";
    sha256 = "sha256:07c7wla0pmg2j1mwdv2ga7jza505rbvghmx5bximsfnq0cairxcv";
  };
in
{
  imports =
    [
      ./hardware-configuration.nix
      server-1c
    ];

  server-1c = {
  	sourceDir = /home/sunder/dev/1c-server/pkgs/1c-server/src;
  	instances = {
  	  "main" = {
  	    enable = true;
  	    version = "8.3.24.1368";
				programs = {
					ibcmd.enable = true;
					ibsrv.enable = true;
				}
  	    services.standalone-server = {
		      enable = true;
		      openFirewall = true;
  	      settings = {
            http.enable = true;
            name = "main";
            data = "/var/lib/usr1cv8/.1cv8/1C/1cv8/standalone-server/";
  	      };
  	    };	
   	  };
      "testing" = {
   	    enable = true;
   	    version = "8.3.24.1439";
				programs = {
					ibcmd.enable = true;
					ibsrv.enable = true;
				}
   	    services.standalone-server = {
   	      enable = true;
   	      openFirewall = true;
   	      settings = {
   	        name = "test";
   	        data = "/var/lib/usr1cv8-testing/.1cv8/1C/1cv8/standalone-server/";
   	        http = {
              enable = true;
   	          port = 8315;
   	        };
   	        debug-port = 1555;
   	        direct-regport = 1542;
   	        direct-range = "1610:1641";
   	        extraArgs = [
   	          "--disable-extended-designer-features"	
   	        ];
   	      };
   	    };
   	  };
  	};
  };
}
