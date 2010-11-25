require 'test_helper'

class GalleryPicturesHelperTest < SharedPicturesHelperTest

  test "should render partial" do
    assert_template :partial => 'pictures/_gallery', :count => 1
  end

  test "should render a gallery, once" do
    assert_select 'div.gallery', 1
  end

#-------------
  private

  def setup
    gallery
  end

end
