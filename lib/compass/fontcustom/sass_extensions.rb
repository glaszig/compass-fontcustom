module Compass
  module Fontcustom
    # Declares extensions for the Sass interpreter
    module SassExtensions

      # Sass function extensions
      module Functions

        # Returns the required `:before` pseudo class styles
        # for the letter at `index` of the font.
        #
        # @param index [FixNum] the font's index
        def letter(index)
          idx = (61696+index.value).to_s(16)
          css = %Q[&:before { content: "\\#{idx}"; }]
          Sass::Script::String.new %Q["\\#{idx}"]
        end
        Sass::Script::Functions.declare :letter, [:index]

      end

    end
  end
end

module Sass::Script::Functions
  include Compass::Fontcustom::SassExtensions::Functions
end
