require 'test_helper'
require File.expand_path('../pictures_private', __FILE__)

class PicturesHelperTest < ActionView::TestCase
  include PicturesHelperTestPrivate

  test "rake should include this tags file" do
#    flunk
  end

  test "tags helper should render tags partial" do
    assert Date::today < Date::new(2010,11,2), 'Test unwritten.'
  end

  test "tags helper should render a list of all tags" do
    all_tags
    assert_select 'div.all-tags'
  end

  test "tags helper should render a tag within a list of all tags" do
    all_tags
    assert_select 'div.all-tags > div.tag'
  end

  test "tags helper should render the right tag name" do
    tag_two
    assert_select 'div.all-tags > div.tag', 'two-name'
  end

end
