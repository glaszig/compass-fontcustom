require 'test_helper'
require 'stringio'
require 'fileutils'

class FontImporterTest < Test::Unit::TestCase

  def setup
    Compass.reset_configuration!
    @project_path = File.expand_path('../../', __FILE__)
    @output_path  = File.join(@project_path, '.output')
    @fonts_path   = File.join(@output_path, 'fonts')
    FileUtils.mkdir_p @fonts_path

    config = StringIO.new <<-SCSS
      project_path = #{@project_path.inspect}
      images_dir   = #{"fixtures".inspect}
      css_dir      = #{".output".inspect}
    SCSS
    Compass.add_configuration(config, "fontcustom_config")
  end

  def teardown
    Compass.reset_configuration!
    FileUtils.rm_r @output_path
  end

  def render(scss)
    scss = %Q(@import "compass"; #{scss})
    options = Compass.sass_engine_options
    options[:line_comments] = false
    options[:style] = :expanded
    options[:syntax] = :scss
    options[:compass] ||= {}
    options[:compass][:logger] ||= Compass::NullLogger.new
    Sass::Engine.new(scss, options).render
  end

  def test_should_generate_font_classes
    fontname = 'myfont'

    css = render <<-SCSS
      @import "#{fontname}/*.svg";
      @include all-myfont-letters;
    SCSS

    assert css =~ %r{.#{fontname}-font}, "base font class missing"
    assert css =~ %r{.icon-#{fontname}-c}i, "icon c css class missing"
    assert css =~ %r{.icon-#{fontname}-d}i, "icon d css class missing"
  end

  def test_should_skip_file_name_hashes_if_option_is_set
    fontname = 'myfont'

    Compass.configuration.fontcustom_hash = false

    css = render <<-SCSS
      @import "#{fontname}/*.svg";
      @include all-myfont-letters;
    SCSS

    assert File.exists? File.join(Compass.configuration.fonts_path, 'myfont.svg')
    assert File.exists? File.join(Compass.configuration.fonts_path, 'myfont.ttf')
    assert File.exists? File.join(Compass.configuration.fonts_path, 'myfont.woff')

    assert css =~ %r{.#{fontname}-font}, "base font class missing"
    assert css =~ %r{.icon-#{fontname}-c}i, "icon c css class missing"
    assert css =~ %r{.icon-#{fontname}-d}i, "icon d css class missing"
  end

end
