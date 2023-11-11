#!/usr/bin/env -S nix-instantiate --eval
let
  lib = import <nixpkgs/lib>;
  nix2html = import ./lib { inherit lib; };
  helloWorldP = nix2html.p { children = lib.singleton (nix2html.text { text = lib.singleton "Hello World"; }); };
in
nix2html.render (nix2html.html {
  attributes = {
    a = "b";
    c = "d";
  };
  children = lib.replicate 3 helloWorldP;
})
