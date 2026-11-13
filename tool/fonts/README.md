# Ethiopic font subset

`assets/fonts/NotoSansEthiopic-Regular.ttf` is subset from the licensed source
font in this directory using the code points in `used-glyphs.txt`. To rebuild
it, install `requirements-font.txt` and run:

```sh
pyftsubset tool/fonts/NotoSansEthiopic-Regular-source.ttf \
  --text-file=tool/fonts/used-glyphs.txt \
  --output-file=assets/fonts/NotoSansEthiopic-Regular.ttf \
  --layout-features='*' --glyph-names --symbol-cmap --legacy-cmap \
  --notdef-glyph --notdef-outline --recommended-glyphs
```

Regenerate `used-glyphs.txt` from the Dart strings and question content before
adding new user-facing text. Keep the Open Font License with the source and
subset font.
