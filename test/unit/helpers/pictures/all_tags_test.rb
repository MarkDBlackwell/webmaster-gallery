require 'test_helper'

class AllTagsPicturesHelperTest < SharedPicturesHelperTest
  tests PicturesHelper

  test "should render partial" do
    render_all_tags
    assert_template :partial => 'pictures/_all_tags'
  end

  test "should render a list of all tags" do
    render_all_tags
    assert_select 'div.all-tags'
  end

end
