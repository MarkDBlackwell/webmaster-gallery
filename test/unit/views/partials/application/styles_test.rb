require 'test_helper'

class StylesApplicationPartialTest < ActionView::TestCase

#pretty html

  test "should render" do
    assert_template :partial => 'application/_styles', :count => 1
  end

  test "should include one style tag" do
    assert_select 'style', 1
    assert_select 'style.styles', 1
    assert_select 'style.styles[type=text/css]', 1
  end

  test "shouldn't display a picture commit button" do
    style_include? 'div.picture > form > input[name=commit] {display: none}'
  end

  test "should render a styling suggestion for a list of all tags" do
    style_include? 'div.all-tags * {display: inline}'
  end

  test "should render a gallery styling suggestion" do
    style_include? 'div.picture {display: inline-block}'
  end

  test "session buttons should be horizontal" do
    style_include? 'div.session-buttons * {display: inline}'
  end

  test "labels should be horizontal" do
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
