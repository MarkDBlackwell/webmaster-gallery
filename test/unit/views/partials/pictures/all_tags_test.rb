require 'test_helper'

class AllTagsPicturesPartialTest < SharedViewTest

  test "should render pretty html source" do
    render_all_tags
    check_pretty_html_source 'All tags', %w[all-tags tag]
  end

  test "should render the right tag name" do
    tag_two
    assert_select 'div.all-tags > div.tag', 'two-name'
  end

  test "all tags partial..." do
    render_all_tags
# Should render:
    assert_template :partial => 'pictures/_all_tags', :count => 1
# Should include one all-tags div:
    assert_select 'div.all-tags', 1
# Should render a tag within a list of all tags:
    assert_select 'div.all-tags > div.tag'
  end

#-------------
  private

  def render_all_tags
    @all_tags = Tag.find(:all)
    render :partial => 'pictures/all_tags'
  end

  def tag_two
# Didn't seem to invoke the ActiveRecord test method, tags:
# ArgumentError: wrong number of arguments (1 for 0)
#    tags(:one).destroy
    @all_tags = Tag.find :all, :conditions => ["name = ?", 'two-name']
    render :partial => 'pictures/all_tags'
  end

end
