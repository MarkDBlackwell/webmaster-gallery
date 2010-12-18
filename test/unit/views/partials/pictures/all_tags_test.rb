require 'test_helper'

class AllTagsPicturesPartialTest < SharedPartialTest

  test "happy path should render..." do
# Pretty html source:
    check_pretty_html_source 'All tags', 'all-tags'
# The right partial, once:
    assert_partial
# One all-tags div:
    s=CssString.new 'div.all-tags'
    assert_select s, 1
# A single tag list:
    assert_select s.child('div.tags'), 1
  end

#-------------
  private

  def setup
    @all_tags=Tag.find :all
    render_partial 'pictures/all_tags'
  end

end
