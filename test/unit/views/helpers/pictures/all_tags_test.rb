require 'test_helper'

class AllTagsPicturesHelperTest < SharedPicturesHelperTest

  test "all tags..." do
# Should render partial:
    assert_template :partial => 'pictures/_all_tags', :count => 1
# Should render a list of all tags:
    assert_select 'div.all-tags', 1
  end

#-------------
  private

  def setup
    render_all_tags
  end

end
