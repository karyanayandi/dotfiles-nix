final: prev: {
  macos-cursors = prev.callPackage ../derivations/macos-cursors.nix {};
  material-symbols = prev.callPackage ../derivations/material-symbols.nix {};

  firefox-gnome-theme = prev.callPackage ../derivations/firefox-gnome-theme.nix {src = prev.firefox-gnome-theme-src;};
}
