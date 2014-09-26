require 'compass/configuration'

# https://github.com/Compass/compass/issues/802

module Compass
  module Configuration
    def self.strip_trailing_separator(*args)
      Data.strip_trailing_separator(*args)
    end
  end
end