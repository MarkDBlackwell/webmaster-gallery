require 'test_helper'

class GalleryPicturesHelperTest < SharedPicturesHelperTest
# %%vi%%he%%pic%%gal %%pic%%pic

  test "happy path should render..." do
# The right partial, once:
    assert_partial 'pictures/_gallery', 1
# A gallery, once:
    assert_select CssString.new('div').css_class('gallery'), 1
  end

#-------------

  def setup
    gallery
  end

end
