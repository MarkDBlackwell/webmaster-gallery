require 'test_helper'

class AllTagsPicturesHelperTest < SharedPicturesHelperTest

  test "happy path..." do
# Should render the right partial, once:
    assert_partial 'pictures/_all_tags', 1
# Should render a list of all tags:
    assert_select 'div.all-tags', 1
  end

#-------------
  private

  def setup
    render_all_tags
  end

end
