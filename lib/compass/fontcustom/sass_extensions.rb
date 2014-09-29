module Compass
  module Fontcustom
    # Declares extensions for the Sass interpreter
    module SassExtensions

      # Sass function extensions
      module Functions

        # Font type format mappings used in css font-face declarations.
        # @see #glyph_font_sources
        FONT_TYPE_OPTIONS = {
          eot: {format: 'embedded-opentype', postfix: '?#iefix'},
          woff: {format: 'woff'},
          ttf: {format: 'truetype'},
          svg: {format: 'svg', postfix: '#%{font_name}'}
        }

        # Returns `:before` pseudo class styles for the letter at `index` of the font.
        #
        # @param index [FixNum] the font's index
        # @return [Sass::Script::String]
        def glyph(index)
          idx = (61696+index.value-1).to_s(16)
          css = %Q[&:before { content: "\\#{idx}"; }]
          Sass::Script::String.new %Q["\\#{idx}"]
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

          map.fonts.each do |font|
            options = FONT_TYPE_OPTIONS[File.extname(font)[1..-1].to_sym]
            url = glyph_font_type_url("#{font}#{options[:postfix]}" % {font_name: map.name})
            src << "#{url} format('#{options[:format]}')"
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
        def glyph_font_type_url(file_path)
          font_file = Sass::Script::String.new File.basename(file_path)
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
