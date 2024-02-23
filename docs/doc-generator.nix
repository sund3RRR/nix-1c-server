{ lib, runCommand, nixosOptionsDoc, ...}: let
  eval = lib.evalModules {
    modules = [
      ../modules/options.nix
    ];
  };
  # generate our docs
  optionsDoc = nixosOptionsDoc {
    inherit (eval) options;
  };
in
# create a derivation for capturing the markdown output
runCommand "options-doc.md" {} ''
  cat ${optionsDoc.optionsCommonMark} >> $out
''
