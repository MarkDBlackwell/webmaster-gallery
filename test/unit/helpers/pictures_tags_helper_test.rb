require 'test_helper'

class PicturesHelperTest < ActionView::TestCase
  include PicturesPrivateAllHelperTest

  test "rake should include this tags file" do
#    flunk
  end

  test "should render tags partial" do
    assert Date::today < Date::new(2010,11,2), 'Test unwritten.'
  end

  test "should render a list of all tags" do
    all_tags
    assert_select 'div.all-tags'
  end

  test "should render a tag within a list of all tags" do
    all_tags
    assert_select 'div.all-tags > div.tag'
  end

  test "should render the right tag name" do
    tag_two
    assert_select 'div.all-tags > div.tag', 'two-name'
  end

end
