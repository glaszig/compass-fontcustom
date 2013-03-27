require "sass/plugin"
require "compass"
require "compass/fontcustom/version"
require "compass/fontcustom/sass_extensions"
require "compass/fontcustom/font_importer"

module Compass
  module Fontcustom
    base_directory  = File.expand_path('../../../', __FILE__)
    Compass::Frameworks.register('fontcustom', :path => base_directory)

    Compass::Configuration.add_configuration_property(:fontcustom_hash, "enables/disables fontcustom file name hashing") do
      true
    end

    Sass.load_paths << FontImporter.new
  end
end