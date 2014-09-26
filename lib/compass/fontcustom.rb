require "compass"
require "compass/fontcustom/version"
require "compass/fontcustom/compass"
require "compass/fontcustom/sass_extensions"
require "compass/fontcustom/glyph_map"
require "compass/fontcustom/font_importer"

module Compass
	# This module registers the gem as a Compass framework source,
	# adds config properties to Compass and extends Sass' `load_paths`.
  module Fontcustom
    base_directory  = File.expand_path('../../../', __FILE__)
    Compass::Frameworks.register('fontcustom', :path => base_directory)

    Compass::Configuration.add_configuration_property(:fontcustom_hash, "enables/disables fontcustom file name hashing") do
      true
    end

    Compass::Configuration.add_configuration_property(:fontcustom_input_paths, "Array of paths where to search for SVG files to build custom fonts from") do
      if defined? Rails
        Rails.application.config.assets.paths
      else
        [Compass.configuration.images_path.to_s]
      end
    end

    Compass::Configuration.add_configuration_property(:fontcustom_fonts_path, "Path to put generated font files in") do
      Compass.configuration.fonts_path.to_s
    end

    Sass.load_paths << FontImporter.new
  end
end