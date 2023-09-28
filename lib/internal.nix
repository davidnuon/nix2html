{lib}:
let
  /*
  Converts an attrset to a list of `{name, value}` pairs.

  Type: attrsToNameValuePair :: AttrSet -> [{ name :: String; value :: Any; }]

  Examples:
    attrsToNameValuePair { a = 1; b = 2; }
    => [
         { name = "a"; value = 1; }
         { name = "b"; value = 2; }
       ]
  */
  attrsToNameValuePair = lib.mapAttrsToList (n: v: {name = n; value = v;});
  isAttrsEmpty = with builtins; attrs: length (attrNames attrs) == 0;
in rec {
  basicElement = {
    name,
    attributes ? {},
    children ? [],
  }: {
    inherit name attributes children;
  };

  /*
  Makes a funciton that models an element with no specific attributes
  (e.g div, p, strong)
  */
  genericElementFactory = name: {
    attributes ? {},
    children ? [],
  }:
    basicElement {
      inherit name attributes children;
    };

  text = with builtins;
    {text}: {
      name = "<TEXT>";
      children =
        foldl'
        (a: b: "${a}${b}")
        ""
        text;
    };

  render = root:
    with builtins; let
      attributeString = let
        pairs = attrsToNameValuePair root.attributes;
        parts = map (p: "${p.name}=\"${p.value}\"") pairs;
        out = foldl' (a: b: "${a} ${b}") "" parts;
      in
        if isAttrsEmpty root.attributes
        then ""
        else "${out}";
      childrenString =
        if length root.children == 0
        then ""
        else foldl' (a: b: "${a}${b}") "" (map render root.children);
    in
      if root.name == "<TEXT>"
      then root.children
      else "<${root.name}${attributeString}>${childrenString}</${root.name}>";
}
