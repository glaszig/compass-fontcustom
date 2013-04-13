require 'fontcustom/generator'

module Compass
  module Fontcustom

    class FontImporter < Sass::Importers::Base
      VAILD_FILE_NAME = /\A#{Sass::SCSS::RX::IDENT}\Z/
      FONT_IMPORTER_REGEX = %r{((.+/)?([^\*.]+))/(.+?)\.svg}
      VALID_EXTENSIONS = ['.svg']

      def self.find_all_font_files(path)
        hex = "[0-9a-f]"
        glob = "fontcustom-#{hex*32}{#{VALID_EXTENSIONS.join(",")}}"
        Dir.glob(File.join(path, "**", glob))
      end

      def find(uri, options)
        if uri =~ FONT_IMPORTER_REGEX
          return self.class.sass_engine(uri, self.class.font_name(uri), self, options)
        end
        nil
      end

      def find_relative(uri, base, options)
        nil
      end

      def to_s
        self.class.name
      end

      def hash
        self.class.name.hash
      end

      def eql?(other)
        other.class == self.class
      end

      def mtime(uri, options)
        self.class.files(uri).sort.inject(Time.at(0)) do |max_time, file|
          (t = File.mtime(file)) > max_time ? t : max_time
        end
      end

      def key(uri, options={})
        [self.class.name + ":fontcustom:" + File.dirname(File.expand_path(uri)), File.basename(uri)]
      end

      def self.path_and_name(uri)
        if uri =~ FONT_IMPORTER_REGEX
          [$1, $3]
        else
          raise Compass::Error, "invalid fonts path"
        end
      end

      def self.font_name(uri)
        _, name = path_and_name(uri)
        name
      end

      def self.path(uri)
        path, _ = path_and_name(uri)
        path
      end

      def self.sass_options(uri, importer, options)
        options.merge!(:filename => uri.gsub(%r{\*/},"*\\/"), :syntax => :scss, :importer => importer)
      end

      def self.sass_engine(uri, name, importer, options)
        content = content_for_fonts(uri, name)
        Sass::Engine.new(content, sass_options(uri, importer, options))
      end

      # Start the Fontcustom generator
      def self.content_for_fonts(uri, name)
        args = []
        args << File.join(Compass.configuration.images_path.to_s, name)
        args << '-o'
        args << Compass.configuration.css_path.to_s
        args << "-n"
        args << name
        args << '--nohash' if Compass.configuration.no_fontcustom_hash
        ::Fontcustom::Generator.start(args)
        File.read(File.join(Compass.configuration.css_path.to_s, 'fontcustom.css'))
      end
    end

  end
end
