require 'test_helper'

class PicturesTagsHelperTest < ActionView::TestCase
  include PicturesPrivateAllHelperTest
  tests PicturesHelper

  test "should include this file" do
#    flunk
  end

  test "should render partial" do
    assert Date::today < Date::new(2010,11,12), 'Test unwritten.'
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

#-------------
  private

  def tag_two
# Didn't seem to invoke the ActiveRecord test method, tags:
# ArgumentError: wrong number of arguments (1 for 0)
#    tags(:one).destroy
    @all_tags = Tag.find :all, :conditions => ["name = ?", 'two-name']
    tags
  end

end
