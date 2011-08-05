require 'test_helper'

class StylesApplicationPartialTest < SharedPartialTest
# %%vi%%part%%app%%sty

  test "happy path should render..." do
# Pretty html source:
    check_pretty_html_source @s.pluralize.capitalize, nil, [@s,'/'+@s]

# The right partial, once:
    assert_partial
# A styling suggestion for a list of all tags:
    include? @d.css_class('tags').child @d.css_class('tag')

# A gallery styling suggestion:
##    include? @dp.descend @dib
    include? @dp
# And...
# Shouldn't display a picture commit button:
    s = @dp.child(CssString.new('form').css_class('edit_picture'),'input').
        attribute('name', 'commit').descend "\n" + (display 'none')
    s = s.gsub " \n", "\n"
    include? s
# Session buttons should be horizontal:
    s = @d.css_class('session-buttons').child(@d,'form').css_class('button_to').
        child(@d).descend "\n" + @di
    s = s.gsub " \n", "\n"
    include? s
# Labels should be horizontal:
    s = @d.css_class('label').descend "\n" + @dib
    s = s.gsub " \n", "\n"
    include? s
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
