module Compass
  module Fontcustom
    # Declares extensions for the Sass interpreter
    module SassExtensions

      # Sass function extensions
      module Functions

        FONT_TYPE_FORMATS = {
          'eot?#iefix'       => 'embedded-opentype',
          'woff'             => 'woff',
          'ttf'              => 'truetype',
          "svg#%{font_name}" => 'svg'
        }

        # Returns the required `:before` pseudo class styles
        # for the letter at `index` of the font.
        #
        # @param index [FixNum] the font's index
        def glyph(index)
          idx = (61696+index.value-1).to_s(16)
          css = %Q[&:before { content: "\\#{idx}"; }]
          Sass::Script::String.new %Q["\\#{idx}"]
        end
        Sass::Script::Functions.declare :letter, [:index]

        def glyph_map(uri)
          GlyphMap.from_uri uri.value, self
        end
        Sass::Script::Functions.declare :glyph_map, [:uri]

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

        def glyph_font_name(map)
          Sass::Script::String.new map.name
        end
        Sass::Script::Functions.declare :glyph_font_name, [:map]

        def glyph_font_name_quoted(map)
          Sass::Script::String.new %Q{"#{map.name}"}
        end
        Sass::Script::Functions.declare :glyph_font_name_quoted, [:map]

        def glyph_font_type_url(map, type)
          type = type % {font_name: map.name}
          file_name = "#{map.filename}.#{type}"
          font_file = Sass::Script::String.new file_name
          font_url(font_file).value
        end

      end

    end
  end
end

module Sass::Script::Functions
  include Compass::Fontcustom::SassExtensions::Functions
end
