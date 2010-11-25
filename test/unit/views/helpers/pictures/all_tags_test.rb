require 'test_helper'

class AllTagsPicturesHelperTest < SharedPicturesHelperTest

  test "should render partial" do
    assert_template :partial => 'pictures/_all_tags'
  end

  test "should render a list of all tags" do
    assert_select 'div.all-tags'
  end

#-------------
  private

  def setup
    render_all_tags
  end

end
