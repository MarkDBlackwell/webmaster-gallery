require 'test_helper'

class PicturesAllTagsPartialTest < ActionView::TestCase

#-------------
# Find method tests:

  test "should include this file" do
#    flunk
  end

  test "should render partial" do
    render :partial => 'pictures/all_tags'
  end

  test "should render a tag within a list of all tags" do
    render_all_tags
    assert_select 'div.all-tags > div.tag'
  end

  test "should render the right tag name" do
    tag_two
    assert_select 'div.all-tags > div.tag', 'two-name'
  end

#-------------
  private

  def render_all_tags
    @all_tags = Tag.find(:all)
#    alltags
    render :partial => 'pictures/all_tags'
  end

  def tag_two
# Didn't seem to invoke the ActiveRecord test method, tags:
# ArgumentError: wrong number of arguments (1 for 0)
#    tags(:one).destroy
    @all_tags = Tag.find :all, :conditions => ["name = ?", 'two-name']
#    render_all_tags
    render :partial => 'pictures/all_tags'
  end

end
