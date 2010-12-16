require 'test_helper'

class TagPicturesPartialTest < SharedPicturesPartialTest

  test "happy path should render..." do
# Pretty html source:
    check_pretty_html_source nil, 'tag'
# The right partial, once:
    assert_partial
    see_output
# Including one tag div:
    assert_select 'div.tag', 1
  end

#-------------
  private

  def setup
    tag=tags :two
    render_partial 'pictures/tag', :tag => tag
  end

end
