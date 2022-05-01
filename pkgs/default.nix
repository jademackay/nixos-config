{ pkgs }:

let
  inherit (pkgs) callPackage ;
in {
  emacs = callPackage ./emacs.nix { };
  rxvt-unicode = callPackage ./rvxt-unicode.nix { };
}
