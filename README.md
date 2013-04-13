# Compass::Fontcustom

This is my attempt of integrating [Font Custom](http://fontcustom.com) with [Compass](http://compass-style.org).

## Installation

Add this line to your application's Gemfile:

    gem 'compass-fontcustom', :git => 'git://github.com/glaszig/compass-fontcustom.git'

And then execute:

    $ bundle

## Usage

Syntactically it works like Compass' sprites feature.  
You can let Font Custom generate your fonts upon Compass' css compilation:

```css
@import "myfont/*.svg"
```

This will import `fontcustom.css` into your stylesheet so that you can use the font `myfont` and the generated classes.

The font files will be searched in your project's `images_path` and be written to the `css_path`.

## Disabling File name hashes

You can choose to disable file name hashes, if you're already using an asset pipeline that handles this for you : 
Use the `no_fontcustom_hash` compass option in `config.rb`

    compass_config do |config|
    	config.no_fontcustom_hash = true
    end

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

[MIT](https://raw.github.com/glaszig/compass-fontcustom/master/LICENSE)
