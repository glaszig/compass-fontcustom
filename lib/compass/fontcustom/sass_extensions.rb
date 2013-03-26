module Compass
  module Fontcustom
    module SassExtensions

      module Functions

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
