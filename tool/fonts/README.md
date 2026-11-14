# Ethiopic font subset

`assets/fonts/NotoSansEthiopic-Regular.ttf` is subset from the licensed source
font in this directory using the code points in `used-glyphs.txt`. That list covers the whole
Ethiopic script (U+1200-1399, U+2D80-2DDE, U+AB01-AB2E), including the Ethiopic punctuation
marks, plus ASCII punctuation, so Amharic typed by players (names, team names, added
questions) never renders as empty boxes. Do not shrink it to only the glyphs in the built-in text. To rebuild
it, install `requirements-font.txt` and run:

```sh
pyftsubset tool/fonts/NotoSansEthiopic-Regular-source.ttf \
  --text-file=tool/fonts/used-glyphs.txt \
  --output-file=assets/fonts/NotoSansEthiopic-Regular.ttf \
  --layout-features='*' --glyph-names --symbol-cmap --legacy-cmap \
  --notdef-glyph --notdef-outline --recommended-glyphs
```

The source font has no Latin glyphs; English text and digits use the platform font. Keep the Open Font License with the source and
subset font.
