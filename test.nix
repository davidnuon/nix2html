#!/usr/bin/env -S nix-instantiate --eval
let
  nix2html = import ./lib;
  helloWorldP = let
    child =
      nix2html.text
      {
        text = ["Hello World"];
      };
  in
    nix2html.p {
      children = [child];
    };
in
  with nix2html;
    render (html {
      attributes = {
        a = "b";
        c = "d";
      };
      children = [
        helloWorldP
        helloWorldP
        helloWorldP
      ];
    })
