require 'test_helper'

class GlyphMapTest < Test::Unit::TestCase

  def setup
    font_path = File.expand_path('../../fixtures/myfont', __FILE__) + '/*.svg'
    @glyph_map = Compass::Fontcustom::GlyphMap.from_uri font_path, nil
  end

  def test_glyph_map
    map = @glyph_map.instance_variable_get(:@glyphs)
    assert !map.empty?
  end

  def test_glyph_index_access
    assert_equal 0, @glyph_map.index_for_glyph('C')
  end

  def test_glyph_name_normalization
    glyphs = @glyph_map.instance_variable_get(:@glyphs)
    assert ! glyphs.include?('google+')
    assert glyphs.include?('google')
  end

end
