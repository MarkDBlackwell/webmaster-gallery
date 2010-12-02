require 'test_helper'

class AllTagsPicturesPartialTest < SharedPartialTest

  test "should render the right tag name" do
    tag_two
    assert_select 'div.all-tags > div.tag', 'two-name'
  end

  test "happy path..." do
    render_all_tags
# Should render pretty html source:
    check_pretty_html_source 'All tags', %w[all-tags tag]
# Should render:
    assert_partial
# Should include one all-tags div:
    assert_select 'div.all-tags', 1
# Should render a tag within a list of all tags:
    assert_select 'div.all-tags > div.tag'
  end

#-------------
  private

  def render_all_tags
    @all_tags = Tag.find(:all)
    render_partial
  end

  def render_partial
    super 'pictures/all_tags'
  end

  def tag_two
# Didn't seem to invoke the ActiveRecord test method, tags:
# ArgumentError: wrong number of arguments (1 for 0)
#    tags(:one).destroy
    @all_tags = Tag.find :all, :conditions => ["name = ?", 'two-name']
    render_partial
  end

end
