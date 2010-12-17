require 'test_helper'

class StylesApplicationPartialTest < SharedPartialTest

  test "happy path should render..." do
# Pretty html source:
    check_pretty_html_source 'Styles', nil, %w[style  /style], 'div.'
# The right partial, once:
    assert_partial
# A styling suggestion for a list of all tags:
    style_include? @d.css_class('all-tags').descend '*', @di
# A gallery styling suggestion:
    style_include? @dp.descend @dib
# And...
# Shouldn't display a picture commit button:
    style_include? @dp.child('form','input').attribute('name', 'commit').
        descend display 'none'
# Session buttons should be horizontal:
    style_include? @d.css_class('session-buttons').descend '*', @di
# Labels should be horizontal:
    style_include? @d.css_class('label').descend @dib
# Include one style tag:
    assert_select @s, 1
    assert_select @ss, 1
    assert_select @ss.attribute('type','text/css'), 1
  end

#-------------
  private

  def assert_select_include?(css, string)
    assert_select css, (Regexp.new Regexp.escape string)
  end

  def display(s)
    CssString.new '{display: '  + s + '}'
  end

  def setup
    render_partial 'application/styles'
    @d, @s = %w[div style].map{|e| CssString.new e}
    @di, @dib = %w[inline inline-block].map{|e| display e}
    @dp=@d.css_class 'picture'
# Fails without CssString.new:
    @ss=CssString.new @s.css_class(@s)+'s'
  end

  def style_include?(substring)
    assert_select_include? @s.attribute('type','text/css'), substring
  end

end
