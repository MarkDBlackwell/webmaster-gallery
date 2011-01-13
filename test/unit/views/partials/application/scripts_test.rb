require 'test_helper'

class ScriptsApplicationPartialTest < SharedPartialTest

  test "scripts div..." do
    tags = %w[prototype effects dragdrop controls rails application]
# Should include certain script tags in order:
    tags.map{|e| Regexp.escape "/javascripts/#{e}.js?"}.each_with_index do |e,i|
      c=@ds.child('script + '*i).descend('script').attribute 'src', '?'
      r=Regexp.new %r"\A#{e}\d+\z"
      assert_select c, r
    end
  end

  test "happy path should render..." do
# Pretty html source:
    check_pretty_html_source 'Scripts', 'scripts', 'script'
# The right partial, once:
    assert_partial
# And...
# Include one scripts div which should include six...:
    assert_select @ds, 1 do
# Tags:
      assert_select @ds.descend('*'), 6
# Script tags:
      assert_select @dss, 6
      assert_select @dss.attribute('type','text/javascript'), 6
    end
# Only those script tags:
    assert_select_only @ds, @dss
  end

#-------------
  private

  def assert_select_only(outer_css,inner_css)
# TODO: change to assert_select with :text option.
    s=css_select(outer_css).to_s
    css_select(inner_css).concat(tag_strings s).each{|e| s=s.gsub e.to_s, ''}
    assert s.split(' ').to_s.empty?, s.strip
  end

  def setup
    render_partial 'application/scripts'
    @d=CssString.new 'div'
    @ds=@d.css_class 'scripts'
    @dss=@ds.descend 'script'
  end

  def tag_strings(s)
    brackets=[?<,?>]
    (0...brackets.length).map do |i|
      m=s.method(0==i ? :index : :rindex)
      a=m.call brackets.at i
      b=m.call brackets.at( (i+1)%2), a
      s.slice(Range.new *[a,b].sort) if a && b
    end
  end

end
