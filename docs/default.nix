{ pkgs ? import <nixpkgs> {} }:
pkgs.callPackage ./doc-generator.nix {}