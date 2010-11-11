require 'test_helper'

class ApplicationStylesPartialTest < ActionView::TestCase

#-------------
# Find method tests:

  test "should include this file" do
#    flunk
  end

  test "should render" do
    render :partial => 'application/styles'
  end

  test "shouldn't display a picture commit button" do
    render :partial => 'application/styles'
    style_include? 'div.picture > form > input[name=commit] {display: none}'
  end

  test "should render a styling suggestion for a list of all tags" do
    render :partial => 'application/styles'
    style_include? 'div.all-tags * {display: inline}'
  end

  test "should render a gallery styling suggestion" do
    render :partial => 'application/styles'
    style_include? 'div.picture {display: inline-block}'
  end

  test "session buttons should be horizontal" do
    render :partial => 'application/styles'
    style_include? 'div.manage-session * {display: inline}'
  end

#-------------
  private

  def style_include?(substring)
    assert_select_include? 'style[type=text/css]', substring
  end

end
