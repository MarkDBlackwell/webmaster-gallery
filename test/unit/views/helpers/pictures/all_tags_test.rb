require 'test_helper'

class AllTagsPicturesHelperTest < SharedPicturesHelperTest

  test "should render partial" do
    assert_template :partial => 'pictures/_all_tags', :count => 1
  end

  test "should render a list of all tags" do
    assert_select 'div.all-tags', 1
  end

#-------------
  private

  def setup
    render_all_tags
  end

end
