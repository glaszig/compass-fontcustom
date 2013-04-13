require 'test_helper'
require 'stringio'
require 'fileutils'

class FontImporterTest < Test::Unit::TestCase

  def setup
    Compass.reset_configuration!
    @images_src_path = File.join(File.dirname(__FILE__), '..', 'fixtures')
    @images_tmp_path = File.join(File.expand_path('../../', __FILE__), 'tmp')
    Dir.mkdir @images_tmp_path

    config = StringIO.new <<-SCSS
      images_path = #{@images_src_path.inspect}
      css_path = #{@images_tmp_path.inspect}
    SCSS
    Compass.add_configuration(config, "fontcustom_config")
  end

  def teardown
    Compass.reset_configuration!
    ::FileUtils.rm_r @images_tmp_path
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

  it "should generate font classes" do
    fontname = 'myfont'

    css = render <<-SCSS
      @import "#{fontname}/*.svg";
    SCSS

    assert File.exists? File.join(Compass.configuration.css_path, 'fontcustom.css')
    assert File.exists? File.join(Compass.configuration.css_path, 'fontcustom-ie7.css')

    assert css =~ %r{.icon-c}
    assert css =~ %r{.icon-d}
  end

  it "should skip file name hashes if option is set" do
    fontname = 'myfont'

    Compass.configuration.no_fontcustom_hash = true

    css = render <<-SCSS
      @import "#{fontname}/*.svg";
    SCSS

    assert File.exists? File.join(Compass.configuration.css_path, 'fontcustom.css')
    assert File.exists? File.join(Compass.configuration.css_path, 'fontcustom-ie7.css')
    assert File.exists? File.join(Compass.configuration.css_path, 'myfont.eot')
    assert File.exists? File.join(Compass.configuration.css_path, 'myfont.svg')
    assert File.exists? File.join(Compass.configuration.css_path, 'myfont.ttf')
    assert File.exists? File.join(Compass.configuration.css_path, 'myfont.woff')


    assert css =~ %r{.icon-c}
    assert css =~ %r{.icon-d}
  end

end
