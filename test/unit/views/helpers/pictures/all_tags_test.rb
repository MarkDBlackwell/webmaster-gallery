require 'test_helper'

class AllTagsPicturesHelperTest < SharedPicturesHelperTest

  test "happy path should render..." do
# The right partial, once:
    assert_partial 'pictures/_all_tags', 1
# A list of all tags:
    assert_select CssString.new('div').css_class('all-tags'), 1
  end

#-------------
  private

  def setup
    @use_controller=:admin_pictures
    render_all_tags
  end

end
