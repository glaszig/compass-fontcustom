require 'erb'
require 'tempfile'
require 'fontcustom/options'
require 'fontcustom/util'
require 'fontcustom/generator/font'

module Compass
  module Fontcustom

    class TemplateData < OpenStruct
      def expose_binding; binding end
    end

    class FontImporter < ::Sass::Importers::Base
      FONT_FILE_REGEX = %r{((.+/)?([^\*.]+))/(.+?)\.(svg|eps)}

      # class methods
      class << self

        def path_and_name(uri)
          if uri =~ FONT_FILE_REGEX
            [$1, $3]
          else
            raise Compass::Error, "invalid fonts path"
          end
        end

        def font_name(uri)
          _, name = path_and_name(uri)
          name
        end

        def path(uri)
          path, _ = path_and_name(uri)
          path
        end

        def letter_names(uri)
          folder = Compass.configuration.images_path.to_s
          files = Dir[File.join(folder, uri)].sort

          if files.empty?
            raise Compass::SpriteException, %Q{No files were found in the fonts path matching "#{uri}". Your current font path is: #{folder}}
          end

          files.map { |f| File.basename(f)[0..-5] }
        end

        def sass_options(uri, importer, options)
          options.merge!(:filename => uri.gsub(%r{\*/},"*\\/"), :syntax => :scss, :importer => importer)
        end

        def sass_engine(uri, name, importer, options)
          generate_font_files(name)
          content = content_for_fonts(uri, name)
          Sass::Engine.new(content, sass_options(uri, importer, options))
        end

        def generate_font_files(name)
          args = {
            :input     => File.join(Compass.configuration.images_path.to_s, name),
            :output    => Compass.configuration.fonts_path.to_s,
            :font_name => name,
            :file_hash => Compass.configuration.fontcustom_hash,
            :verbose   => false
          }
          ::Fontcustom::Generator::Font.start [args]
        end

        # Start the Fontcustom generator
        def content_for_fonts(uri, name)
          erb    = File.join(template_path, 'stylesheet.scss.erb')
          binder = TemplateData.new(:name => name, :path => fonts_path, :letter_names => letter_names(uri))
          file   = Tempfile.open('fontcustom.css')
          begin
            file.write ERB.new(File.read(erb)).result(binder.expose_binding)
          ensure
            file.close
          end
          File.read file.path
        end

        def fonts_path
          Compass.configuration.fonts_dir.to_s
        end

        def template_path
          File.expand_path('../templates', __FILE__)
        end

      end # end class methods

      def find(uri, options)
        if uri =~ FONT_FILE_REGEX
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

      def files(uri)
        folder = Compass.configuration.fonts_path.to_s
        files = Dir[File.join(folder, uri)]
        files
      end

      def mtime(uri, options)
        files(uri).sort.inject(Time.at(0)) do |max_time, file|
          (t = File.mtime(file)) > max_time ? t : max_time
        end
      end

      def key(uri, options={})
        [self.class.name + ":fontcustom:" + File.dirname(File.expand_path(uri)), File.basename(uri)]
      end

    end

  end
end
