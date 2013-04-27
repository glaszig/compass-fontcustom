require 'erb'
require 'tempfile'
require 'fontcustom/error'
require 'fontcustom/options'
require 'fontcustom/util'
require 'fontcustom/generator/font'

module Compass
  module Fontcustom

    # Just an `OpenStruct` to contain template variables.
    # @see FontImporter#content_for_font
    class TemplateData < OpenStruct
      # Returns the intance's internal `binding`.
      def expose_binding; binding end
    end

    # The Sass Importer responsible to find svg and eps files
    # and to start the Fontcustom font generator.
    class FontImporter < ::Sass::Importers::Base

      # Regexp matching uri's of svg and eps files
      FONT_FILE_REGEX = %r{((.+/)?([^\*.]+))/(.+?)\.(svg|eps)}

      # class methods
      class << self

        # Returns an array with two elements.
        # First the path, second the file name of the `uri`.
        def path_and_name(uri)
          if uri =~ FONT_FILE_REGEX
            [$1, $3]
          else
            raise Compass::Error, "invalid fonts path"
          end
        end

        # Returns only the file name component of `uri`.
        # @see path_and_name
        def font_name(uri)
          _, name = path_and_name(uri)
          name
        end

        # Returns only the path component of `uri`
        # @see path_and_name
        def path(uri)
          path, _ = path_and_name(uri)
          path
        end

        # Returns all glyph names inside the folder at `uri`.
        # @return [Array]
        def glyph_names(uri)
          folder = Compass.configuration.images_path.to_s
          files  = Dir[File.join(folder, uri)].sort

          if files.empty?
            raise Compass::SpriteException, %Q{No files were found in the fonts path matching "#{uri}". Your current font path is: #{folder}}
          end

          files.map { |f| File.basename(f)[0..-5] }
        end

        # Returns `Sass::Engine` options with defaults
        # @return [Hash]
        def sass_options(uri, importer, options)
          options.merge!(:filename => uri.gsub(%r{\*/},"*\\/"), :syntax => :scss, :importer => importer)
        end

        # Returns a `Sass::Engine`
        # @return [Sass::Engine]
        def sass_engine(uri, name, importer, options)
          content = content_for_font(uri, name)
          Sass::Engine.new(content, sass_options(uri, importer, options))
        end

        # Renders the stylesheet for font `name` at `uri`
        # @return [String]
        def content_for_font(uri, name)
          erb    = File.read File.join(template_path, 'stylesheet.scss.erb')
          binder = TemplateData.new(uri: uri, name: name, path: fonts_path, glyph_names: glyph_names(uri))
          ERB.new(erb).result(binder.expose_binding)
        end

        # Returns the fonts path
        # @return [String]
        def fonts_path
          Compass.configuration.fonts_dir.to_s
        end

        # Returns the gems' internal template path.
        # @return [String]
        def template_path
          File.expand_path('../templates', __FILE__)
        end

        # Returns an array of font files.
        # @param uri [String] a URI
        # @return [Array]
        def files(uri)
          folder = Compass.configuration.images_path.to_s
          files = Dir[File.join(folder, uri)]
          files
        end

      end # end class methods

      # Resolves incoming uri from an `@import "..."` directive.
      # @param uri [String] the uri from the import directive
      # @param options [Hash] options for the returned Sass::Engine`
      # @return [Sass::Engine]
      def find(uri, options)
        if uri =~ FONT_FILE_REGEX
          return self.class.sass_engine(uri, self.class.font_name(uri), self, options)
        end
        nil
      end

      def find_relative(uri, base, options)
        nil
      end

      # Returns the string representation of this instance.
      # @return [String]
      def to_s
        self.class.name
      end

      # Returns the hash of this instance.
      # @return [String]
      def hash
        self.class.name.hash
      end

      # Compares this instance with another object.
      # @param other [Object] another object
      # @return [Boolean]
      def eql?(other)
        other.class == self.class
      end

      def mtime(uri, options)
        files(uri).sort.inject(Time.at(0)) do |max_time, file|
          (t = File.mtime(file)) > max_time ? t : max_time
        end
      end

      # This instance's Compass cache key
      # @return [Array]
      def key(uri, options={})
        [self.class.name + ":fontcustom:" + File.dirname(File.expand_path(uri)), File.basename(uri)]
      end

    end

  end
end
