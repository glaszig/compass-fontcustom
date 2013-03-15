require "sass/plugin"
require "compass"
require "compass/fontcustom/version"
require "compass/fontcustom/font_importer"

module Compass
  module Fontcustom
		Sass.load_paths << FontImporter.new
  end
end