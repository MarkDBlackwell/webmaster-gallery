require 'test_helper'

class GalleryPicturesHelperTest < SharedPicturesHelperTest

  test "happy path..." do
# Should render partial:
    assert_template :partial => 'pictures/_gallery', :count => 1
# Should render a gallery, once:
    assert_select 'div.gallery', 1
  end

#-------------
  private

  def setup
    gallery
  end

end
