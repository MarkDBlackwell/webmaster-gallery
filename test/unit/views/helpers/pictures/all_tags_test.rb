require 'test_helper'

class AllTagsPicturesHelperTest < SharedPicturesHelperTest
# %%vi%%he%%pic%%atgs

  test "happy path should render..." do
# The right partial, once:
    assert_partial 'pictures/_all_tags', 1
# A list of all tags:
    assert_select CssString.new('div').css_class('all-tags'), 1
  end

#-------------
  private

  def setup
    c=:pictures
    @controller.default_url_options={:controller=>c}
    render_all_tags
  end

end
