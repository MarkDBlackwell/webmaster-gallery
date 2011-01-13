require 'test_helper'

class StylesApplicationPartialTest < SharedPartialTest

  test "happy path should render..." do
# Pretty html source:
    check_pretty_html_source @s.pluralize.capitalize, nil, [@s,'/'+@s], @d+'.'
# The right partial, once:
    assert_partial
# A styling suggestion for a list of all tags:
    include? @d.css_class('tags').descend '*', @di
# A gallery styling suggestion:
    include? @dp.descend @dib
# And...
# Shouldn't display a picture commit button:
    include? @dp.child('form','input').attribute('name', 'commit').
        descend display 'none'
# Session buttons should be horizontal:
    include? @d.css_class('session-buttons').descend '*', @di
# Labels should be horizontal:
    include? @d.css_class('label').descend @dib
# Include one style tag:
    assert_single [@s,'class'], @s+'s'
    assert_single [@s,'type' ], 'text/css'
  end

#-------------
  private

  def assert_select_include?(css, string)
    assert_select css, (Regexp.new Regexp.escape string)
  end

  def display(s)
    CssString.new '{display: ' + s + '}'
  end

  def setup
    render_partial 'application/styles'
    @d,@s = %w[div style].map{|e| CssString.new e}
    @di,@dib = %w[inline inline-block].map{|e| display e}
    @dp=@d.css_class 'picture'
  end

  def include?(substring)
    assert_select_include? @s.attribute('type','text/css'), substring
  end

end
