require 'test_helper'

class PicturesHelperTest < ActionView::TestCase
  include PicturesPrivateAllHelperTest

  test "should include this tags file" do
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
