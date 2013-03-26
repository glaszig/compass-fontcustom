require 'test_helper'
require 'stringio'
require 'fileutils'

class FontImporterTest < Test::Unit::TestCase

  def setup
    Compass.reset_configuration!
    @project_path = File.expand_path('../../', __FILE__)
    @tmp_path = File.join(@project_path, 'tmp')
    @fonts_tmp_path = File.join(@tmp_path, 'fonts')
    Dir.mkdir @tmp_path

    config = StringIO.new <<-SCSS
      project_path = #{@project_path.inspect}
      css_path = #{@tmp_path.inspect}
      fonts_dir = #{"fixtures".inspect}
    SCSS
    Compass.add_configuration(config, "fontcustom_config")
  end

  def teardown
    Compass.reset_configuration!
    ::FileUtils.rm_r @tmp_path
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

    assert css =~ %r{.icon-c}i, "icon css class missing"
    assert css =~ %r{.icon-d}i, "icon css class missing"
  end

  it "should skip file name hashes if option is set" do
    fontname = 'myfont'

    Compass.configuration.fontcustom_hash = false

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
