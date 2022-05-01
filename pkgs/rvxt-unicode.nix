{ pkgs }:
let
  perlSupport = true;
  unicode3Support  = true ;
in
pkgs.rxvt-unicode-unwrapped.overrideAttrs (oldAttrs: {
  configureFlags = [
    "--with-terminfo=${placeholder "terminfo"}/share/terminfo"
    "--enable-everything"
    (pkgs.lib.strings.enableFeature perlSupport "perl")
    (pkgs.lib.strings.enableFeature unicode3Support "unicode3")
  ];
})
  
