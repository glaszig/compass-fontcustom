require "sass/plugin"
require "compass"
require "compass/fontcustom/version"
require "compass/fontcustom/sass_extensions"
require "compass/fontcustom/font_importer"

module Compass
  module Fontcustom
    Sass.load_paths << FontImporter.new

    Compass::Configuration.add_configuration_property(:fontcustom_hash, "enables/disables fontcustom file name hashing") do
      true
    end
  end
end