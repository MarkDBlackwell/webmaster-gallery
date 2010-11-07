require 'test_helper'

class PicturesTagsHelperTest < ActionView::TestCase
  include PicturesPrivateAllHelperTest
  tests PicturesHelper

  test "should include this file" do
#    flunk
  end

  test "should render partial" do
# TODO  test "should render partial" do
    assert Date::today < Date::new(2010,11,12), 'Test unwritten.'
  end

  test "should render a list of all tags" do
    render_all_tags
    assert_select 'div.all-tags'
  end

end
