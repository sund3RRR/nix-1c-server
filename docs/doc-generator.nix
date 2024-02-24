{ lib, runCommand, nixosOptionsDoc, ...}: let
  server-1c = builtins.fetchTarball {  
    url = "https://github.com/sund3RRR/nix-1c-server/archive/412507cf4b58e3174ab17e4d78cb13bbdd046645.tar.gz";  
    sha256 = "sha256:07c7wla0pmg2j1mwdv2ga7jza505rbvghmx5bximsfnq0cairxcv";  
  };
  eval = lib.evalModules {
    modules = [
      ../modules/options.nix
    ];
  };
  # generate our docs
  optionsDoc = nixosOptionsDoc {
    inherit (eval) options;
     transformOptions = opt:
      opt
      // {
        declarations = with lib;
          map (decl:
            {
              url = "https://github.com/sund3RRR/nix-1c-server/blob/main/modules/options.nix";
              name = "/modules/options.nix";
            }) opt.declarations;
      };
  };
in
# create a derivation for capturing the markdown output
runCommand "options-doc.md" {} ''
  cat ${optionsDoc.optionsCommonMark} >> $out
''
