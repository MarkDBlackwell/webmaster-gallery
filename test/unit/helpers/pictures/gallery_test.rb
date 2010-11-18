require 'test_helper'

class PicturesGalleryHelperTest < ActionView::TestCase
  include PicturesHelperTestShared
  tests PicturesHelper

  test "should render partial" do
    gallery
    assert_template :partial => 'pictures/_gallery'
  end

  test "should render a gallery, once" do
    gallery
    assert_select 'div.gallery', 1
  end

end
