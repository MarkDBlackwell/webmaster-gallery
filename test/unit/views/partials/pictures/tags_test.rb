require 'test_helper'

class TagsPicturesPartialTest < SharedPartialTest

  test "should render the right tag name" do
    tag_two
    assert_select 'div.tags > div.tag', 'two-name'
  end

  test "happy path should render..." do
    render_all_tags
# Pretty html source:
    check_pretty_html_source nil, %w[tags  tag]
# The right partial, once:
    assert_partial
# The tag partial the right number of times:
    assert_partial 'pictures/_tag', 2
# One all-tags div:
    s=CssString.new 'div.tags'
    assert_select s, 1 do
# At least one tag within a list of all tags:
      assert_select s.child 'div.tag'
    end
  end

#-------------
  private

  def render_all_tags
    @tags=Tag.find :all
    render_partial
  end

  def render_partial
    @use_controller=:admin_pictures
    super 'pictures/tags', :tags => @tags
  end

  def tag_two
# Didn't seem to invoke the ActiveRecord test method, tags:
# ArgumentError: wrong number of arguments (1 for 0):
#       tags(:one).destroy
    @tags=Tag.find :all, :conditions => ['name = ?', 'two-name']
    render_partial
  end

end
