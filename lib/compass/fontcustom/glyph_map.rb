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
        args = self.class.config.generator_options || {}
        args.merge!(
          :input     => path,
          :output    => output_dir,
          :font_name => @name,
          :no_hash   => !Compass.configuration.fontcustom_hash,
          :quiet     => true,
          :fonts     => []
        )
        ::Fontcustom::Base.new(args).compile
      end

      def filename
        file = glob.first
        File.basename file, File.extname(file)
      end

      def output_dir
        Compass.configuration.fontcustom_fonts_path
      end

      def to_s
        @name.to_s
      end

      protected

        def glob
          glob = File.join output_dir, "#{self.name}*"
          Dir[glob]
        end

    end
  end
end
