module Compass
  module Fontcustom
    # Declares extensions for the Sass interpreter
    module SassExtensions

      # Sass function extensions
      module Functions

        # Font type format mappings used in css font-face declarations.
        # @see #glyph_font_sources
        FONT_TYPE_FORMATS = {
          'eot?#iefix'       => 'embedded-opentype',
          'woff'             => 'woff',
          'ttf'              => 'truetype',
          "svg#%{font_name}" => 'svg'
        }

        # Returns `:before` pseudo class styles for the letter at `index` of the font.
        #
        # @param map [Compass::Fontcustom::GlyphMap] a glyph map
        # @param glyph [String] glyph name
        # @return [Sass::Script::String]
        def glyph(map, glyph)
          # Name transform should be implemented as in FontCustom
          code = map.codepoint glyph.to_s.gsub(/^"|"$/, '').gsub(/[.+{};]+/, ' ').gsub(/[ ]+/, '-')
          Sass::Script::String.new "'\\#{code.to_i.to_s(16)}'"
        end
        Sass::Script::Functions.declare :letter, [:index]

        # Returns a `GlyphMap` representing a font.
        #
        # @param uri [String] the uri to glob files from
        # @return [Compass::Fontcustom::GlyphMap] a glyph map
        def glyph_map(uri)
          GlyphMap.from_uri uri.value, self
        end
        Sass::Script::Functions.declare :glyph_map, [:uri]

        # Returns all `url(...) format(...)` definitions for the font files of the `map`.
        #
        # @param map [Compass::Fontcustom::GlyphMap] a glyph map
        # @return [Sass::Script::String]
        def glyph_font_sources(map)
          map.generate
          src = []
          FONT_TYPE_FORMATS.each do |type, format|
            url = glyph_font_type_url map, type
            src << "#{url} format('#{format}')"
          end
          Sass::Script::String.new src.join ", "
        end
        Sass::Script::Functions.declare :glyph_font_sources, [:map]

        # Retuns the font name of `map`.
        #
        # @param map [Compass::Fontcustom::GlyphMap] a glyph map
        # @return [Sass::Script::String]
        def glyph_font_name(map)
          Sass::Script::String.new map.name
        end
        Sass::Script::Functions.declare :glyph_font_name, [:map]

        # Returns the font name of `map in quotes
        #
        # @param map [Compass::Fontcustom::GlyphMap] a glyph map
        # @return [Sass::Script::String]
        def glyph_font_name_quoted(map)
          Sass::Script::String.new %Q{"#{map.name}"}
        end
        Sass::Script::Functions.declare :glyph_font_name_quoted, [:map]

        # Helper method. Returns a `Sass::Script::Functions#font_url for the font of `type` in `map`.
        #
        # @return [String]
        def glyph_font_type_url(map, type)
          type = type % {font_name: map.name}
          file_name = "#{map.filename}.#{type}"
          font_file = Sass::Script::String.new file_name
          font_url(font_file).value
        end

        def sanitize_symbol(name)
          sanitized = name.value.to_s.gsub(/[.+{};]+/, ' ').strip.gsub(/[ ]+/, '-')
          Sass::Script::String.new sanitized
        end
        Sass::Script::Functions.declare :sanitize_symbol, [:name]

      end

    end
  end
end

module Sass::Script::Functions
  include Compass::Fontcustom::SassExtensions::Functions
end
