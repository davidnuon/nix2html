#!/usr/bin/env -S nix-instantiate --eval
let
  pkgs = import <nixpkgs> {};
  inherit (pkgs) lib;
  nix2html = import ./lib.nix {inherit lib;};
  p = let
    child =
      nix2html.textNode
      {
        text = ["Hello"];
      };
  in
    nix2html.basicElement {
      name = "p";
      children = [
        child
      ];
    };
in
  with nix2html;
    render {
      root = basicElement {
        name = "html";
        attributes = {
          a = "b";
          c = "d";
        };
        children = [
          p
          p
          p
        ];
      };
    }
