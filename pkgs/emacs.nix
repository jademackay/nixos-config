{ emacs, emacsMacport, hostPlatform }:

let
  # For bonus points so we support Mac OS as well
  emacsPlatform = if hostPlatform.isDarwin then emacsMacport else emacs;

in emacsPlatform.pkgs.withPackages (epkgs: with epkgs.melpaStablePackages; [
  company
  counsel
  flycheck
  julia-mode
  nix-mode
  ivy
  magit
  projectile
  use-package
])
  
