require 'test_helper'

class StylesApplicationPartialTest < SharedViewTest

  test "should render pretty html source" do
    check_pretty_html_source 'Styles', nil, %w[style /style], 'div.'
  end

  test "styles partial..." do
# Should render:
    assert_template :partial => 'application/_styles', :count => 1
# Should include one style tag:
    assert_select 'style', 1
    assert_select 'style.styles', 1
    assert_select 'style.styles[type=text/css]', 1
# Shouldn't display a picture commit button:
    style_include? 'div.picture > form > input[name=commit] {display: none}'
# Should render a styling suggestion for a list of all tags:
    style_include? 'div.all-tags * {display: inline}'
# Should render a gallery styling suggestion:
    style_include? 'div.picture {display: inline-block}'
# Session buttons should be horizontal:
    style_include? 'div.session-buttons * {display: inline}'
# Labels should be horizontal:
    style_include? 'div.label {display: inline-block}'
  end

#-------------
  private

  def assert_select_include?(css, string)
    assert_select css, Regexp.new(Regexp.escape string)
  end

  def setup
    render :partial => 'application/styles'
  end

  def style_include?(substring)
    assert_select_include? 'style[type=text/css]', substring
  end

end
