# Changelog

**1.3.1** Minor release

 - Use FontCustom's codepoints when regenerating fonts to add/remove glyphs -- #19
 - Fixed an issue picking up the wrong font filename -- #18
 - Dropped Ruby 1.9 support
 - Testing on all Ruby 2.x versions
 - Deprecated options `fontcustom_fonts_path` in favor of `fontcustom_options`

**1.3.0** Major release

 - Bundles Fontcustom 1.3.0 -- #10
 - Fixes an issue where fonts are not regenerated -- #11
 - Adds Compass configuration option `fontcustom_input_paths` -- #12
 - Adds Compass configuration option `fontcustom_fonts_path` -- #13
 - Officially supporting Compass 1.0

**1.2.0** Major release

 - Bundles Fontcustom 1.2.0
 - **Compatibility**: CSS class name and glyph name normalization have been decoupled. See the readme for details.
 - Extended documentation in the readme.

**1.1.0** Minor release

 - Bundles Fontcustom 1.1.0
 - Adds proper support for Rails' asset pipeline. Should work with Rails >= 3.1, tested with 4.0.
 - Changes/fixes behavior of naming CSS classes: Special characters, other than a-z and 0-9, are now being stripped when generating class names from glyph file names to prevent CSS from throwing up:  

   File name `google+.svg` becomes class name `.icon-yourfont-google` -- without the `+` sign.

**1.0.0** Feature release

 - Adding mixin for generating custom glyph classes

**1.0.0.pre3** Bugfix release

 - Fixing CSS class <-> glyph mapping

**1.0.0.pre2** Maintenance release

 - Depending on fontcustom 1.0.0.pre2

**1.0.0.pre**

 - Designed to work with fontcustom 1.0.0.pre
 - Leveraging fontcustom's new `Fontcustom::Generator::Font` to generate font without stylesheets
 - Generating custom stylesheet (see `lib/compass/fontcustom/templates/stylesheet.scss.erb) via mixins
 - After `@import`ing your font you now need to `@include all-font-name-glyphs` to have classes available
 - Font glyph class names follow this naming scheme: `.icon-<font>-<glyph>`
 - New Sass function: `glyph(index)` which yields `:before` styles with proper index pointing at a specific glyph  
   Example:  
   `&:before { content: "\<index>"; }`

**0.0.1**

 - obsolete. doesn't matter anymore.

