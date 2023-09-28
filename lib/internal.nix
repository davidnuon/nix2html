let
  attrsToList = with builtins;
    attrs: (map (key: {
      name = key;
      value = getAttr key attrs;
    }) (attrNames attrs));
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

  render = {root}:
    with builtins; let
      attributeString = let
        pairs = attrsToList root.attributes;
        parts = map (p: "${p.name}=\"${p.value}\"") pairs;
        out = foldl' (a: b: "${a} ${b}") "" parts;
      in
        if isAttrsEmpty root.attributes
        then ""
        else "${out}";
      childrenString =
        if length root.children == 0
        then ""
        else foldl' (a: b: "${a}${b}") "" (map (c: render {root = c;}) root.children);
    in
      if root.name == "<TEXT>"
      then root.children
      else "<${root.name}${attributeString}>${childrenString}</${root.name}>";
}
