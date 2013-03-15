require 'test_helper'
require 'stringio'
require 'fileutils'

class FontImporterTest < Test::Unit::TestCase

  def setup
    Compass.reset_configuration!
    @images_src_path = File.join(File.dirname(__FILE__), '..', 'fixtures', 'svg')
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
    css = render <<-SCSS
      @import "myfont/*.svg";
    SCSS

    assert css =~ %r{.icon-c}
    assert css =~ %r{.icon-d}
  end

end