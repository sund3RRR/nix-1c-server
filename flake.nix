{
  description = "1C server flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }: {
    nixosModules.server-1c = import ./modules/1c-server.nix;
  };
}
