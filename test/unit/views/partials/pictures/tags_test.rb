require 'test_helper'

class TagsPicturesPartialTest < SharedPartialTest
# %%vi%%part%%pic%%tgs %%pic%%tag

  test "should render the right tag name" do
    tag_two
    assert_single @ds, 'two-name'
  end

  test "happy path should render..." do
    render_all_tags
# Pretty html source:
    check_pretty_html_source nil, %w[tags  tag]
# The right partial, once:
    assert_partial
# The tag partial, twice:
    assert_partial 'pictures/_tag', 2
# A single all-tags div:
    assert_select @dt, 1 do
# At least one tag within a list of all tags:
      assert_select @ds
    end
  end

#-------------
  private

  def render_all_tags
    @tags=Tag.all
    render_partial
  end

  def render_partial
    @use_controller=:admin_pictures
    super 'pictures/tags', :tags => @tags
  end

  def setup
    @d=CssString.new 'div'
    @dt=@d.css_class 'tags'
    @ds=@dt.child(@d).css_class 'tag'
  end

  def tag_two
# Didn't seem to invoke the ActiveRecord test method, tags:
# working on
# ArgumentError: wrong number of arguments (1 for 0):
##       tags(:one).destroy
    @tags=Tag.where :name => 'two-name'
    render_partial
  end

end
