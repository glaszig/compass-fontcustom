module Compass
  module Fontcustom
    module Util
      class << self
        def sanitize_symbol name
          name.to_s.gsub(/^"|"$/,    '') \
                   .gsub(/[.+{};]+/, ' ') \
                   .gsub(/[ ]+/,     '-')
        end
      end
    end
  end
end