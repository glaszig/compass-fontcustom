# Compass::Fontcustom

[![Build Status](https://travis-ci.org/glaszig/compass-fontcustom.png?branch=master)](https://travis-ci.org/glaszig/compass-fontcustom)
[![Gem Version](https://badge.fury.io/rb/compass-fontcustom.png)](http://badge.fury.io/rb/compass-fontcustom)
[![Test Coverage](https://coveralls.io/repos/glaszig/compass-fontcustom/badge.png?branch=master)](https://coveralls.io/r/glaszig/compass-fontcustom)

This is my attempt of integrating [Font Custom](http://fontcustom.com) with [Compass](http://compass-style.org).

## Requirements

Tested on Ruby 2.0, 2.1, 2.2, 2.3 and 2.4.  
You'll need to have fontforge and the [WOFF font toolset](http://people.mozilla.com/~jkew/woff) installed as outlined in the Font Custom [installation instructions](http://fontcustom.com/#installation).

## Installation

Add this line to your application's Gemfile:

    gem 'compass-fontcustom'

or:

    gem 'compass-fontcustom', :github => 'glaszig/compass-fontcustom'

And then execute:

    $ bundle

## Configuration

Compass::Fontcustom adds the following configuration options to Compass.  
Just add these to your project's `config/compass.rb`.

- `fontcustom_input_paths`  
  Array of paths where to search for SVG files to build custom fonts from.
- `fontcustom_discard_manifest`  
  Boolean to configure to delete the manifest file after each run.
- `fontcustom_options`  
  A hash to pass native options to FontCustom.

## Usage

Syntactically it works like Compass' sprites feature.  
You can let Font Custom generate your fonts upon Compass' css compilation:

```css
@import "myfont/*.svg";
@include all-myfont-glyphs;
```

This will setup a proper `@font-face` and generate icon classes named `.icon-<font_name>-<glyph_name>` for each glyph.

### Custom class names

You can also use custom class names using the `<font_name>-glyph()` mixin:

```css
.custom-class-name {
  @include myfont-glyph(glyph-file-name);
}
```

which will result into CSS along the lines of:

```css
.myfont-font, .custom-class-name {
  font-family: "myfont";
}
.custom-class-name:before {
  content: "\f100";
}
```

> **Attention**  
> Generated CSS class names will be normalized and reserved characters removed.  
> That means if you have a glyph file name of `a_R3ally-eXotic f1Le+Name.svg` the generated class name will be `.icon-myfont-a_R3ally-eXotic-f1Le-Name`.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

[MIT](https://raw.github.com/glaszig/compass-fontcustom/master/LICENSE)
