{ pkgs ?  import <nixpkgs> {}
, firmware ? import ../src {}
}:

let
  config = ./.;

  # Only the left half is patched: it is the split central, so it alone knows the active layer.
  glove80_left  = (firmware.zmk.override { board = "glove80_lh"; keymap = "${config}/glove80.keymap"; kconfig = "${config}/glove80.conf"; }).overrideAttrs (old: {
    patches = (old.patches or []) ++ [ ./rgb-layer-indicator.patch ];
  });
  glove80_right = firmware.zmk.override { board = "glove80_rh"; keymap = "${config}/glove80.keymap"; kconfig = "${config}/glove80.conf"; };

in firmware.combine_uf2 glove80_left glove80_right
