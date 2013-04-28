require 'fontcustom/generator/font'
require 'compass/fontcustom/configurable'

module Compass
  module Fontcustom
    class GlyphMap < Sass::Script::Literal
      include Configurable

      attr_reader :name, :path

      # @param context [Object] usually an instance of FontImporter
      def self.from_uri(uri, context)
        path, name = FontImporter.path_and_name uri
        glyphs = FontImporter.files(uri).sort.map { |file| File.basename(file)[0..-5] }
        new glyphs, path, name, context
      end

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
        unless exists?
          args = self.class.config.generator_options || {}
          args.merge!(
            :input     => File.join(Compass.configuration.images_path.to_s, self.path),
            :output    => output_dir,
            :font_name => @name,
            :file_hash => Compass.configuration.fontcustom_hash,
            :verbose   => false
          )
          ::Fontcustom::Generator::Font.start [args]
        end
      end

      def filename
        file = glob.first
        File.basename file, File.extname(file)
      end

      def exists?
        not glob.empty?
      end

      def output_dir
        Compass.configuration.fonts_path.to_s
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
