require 'fontcustom'
require 'compass/fontcustom/configurable'
require 'thor'

module Compass
  module Fontcustom
    class GlyphMap < Sass::Script::Literal
      include Configurable

      attr_reader :name, :path

      # @param context [Object] usually an instance of FontImporter
      def self.from_uri(uri, context)
        path, name = FontImporter.path_and_name uri
        glyphs = FontImporter.files(uri).sort

        # TODO: improve extraction of aboslute path
        path = File.dirname glyphs.first
        glyphs.map! { |file| File.basename(file)[0..-5] }

        new glyphs, path, name, context
      end

      # @param glyphs [Array] all the glyphs found at path
      # @param path [String] the absolute path where glyphs are stored
      # @param name [String] the name of the glyph font
      # @param context [Object] the invoking object
      def initialize(glyphs, path, name, context)
        raise StandardError, "No glyphs found at '#{path}'" if glyphs.empty?
        @glyphs = glyphs
        @path   = path
        @name   = name
        @context = context
      end

      def index_for_glyph(name)
        @glyphs.index name
      end

      # Starts the Fontcustom font generator to write font files to disk.
      def generate
        args = (self.class.config.generator_options || {}).
          merge(output: Compass.configuration.fonts_path.to_s, quiet: true, fonts: []).
          merge(Compass.configuration.fontcustom_options).
          merge(font_name: @name, input: path)
        @fontcustom = ::Fontcustom::Base.new(args)
        @fontcustom.compile
      end

      def fonts
        @fontcustom.manifest.get(:fonts) if @fontcustom
      end

      def to_s
        @name.to_s
      end
    end
  end
end
