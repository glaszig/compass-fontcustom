# Compass::Fontcustom [![Build Status](https://travis-ci.org/glaszig/compass-fontcustom.png?branch=experimental)](https://travis-ci.org/glaszig/compass-fontcustom)

This is my attempt of integrating [Font Custom](http://fontcustom.com) with [Compass](http://compass-style.org).

## Installation

Add this line to your application's Gemfile:

    gem 'compass-fontcustom'

or:

    gem 'compass-fontcustom', :github => 'glaszig/compass-fontcustom'

And then execute:

    $ bundle

## Usage

Syntactically it works like Compass' sprites feature.  
You can let Font Custom generate your fonts upon Compass' css compilation:

```css
@import "myfont/*.svg";
@include all-myfont-glyphs;
```

This will import `fontcustom.css` into your stylesheet so that you can use the font `myfont` and the generated classes.

The font files will be searched in `images_path/myfont` and be written to Compass' `fonts_path`.

## Disabling file name hashes

You can choose to disable file name hashes if you're already using an asset pipeline that handles this for you:
Use the `fontcustom_hash` compass option in `config.rb`

```ruby
compass_config do |config|
  config.fontcustom_hash = false
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

[MIT](https://raw.github.com/glaszig/compass-fontcustom/master/LICENSE)
