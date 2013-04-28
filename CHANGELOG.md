# Changelog

**1.0.0.pre**

 - Designed to work with fontcustom 1.0.0.pre
 - Leveraging fontcustom's new `Fontcustom::Generator::Font` to generate font without stylesheets
 - Generating custom stylesheet (see `lib/compass/fontcustom/templates/stylesheet.scss.erb) via mixins
 - After `@import`ing your font you now need to `@include all-font-name-letters` to have classes available
 - Font letter class names follow this naming scheme: `.icon-<font>-<letter>`
 - New Sass function: `letters(index)` which yields `:before` styles with proper index pointing at a specific glyph  
   Example:  
   `&:before { content: "\<index>"; }`

**0.0.1**

 - obsolete. doesn't matter anymore.

