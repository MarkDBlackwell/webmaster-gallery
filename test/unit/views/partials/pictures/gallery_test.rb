require 'test_helper'

class GalleryPicturesPartialTest < ActionView::TestCase
  helper PicturesHelper

  test "should render" do
    assert_template :partial => 'pictures/_gallery'
  end

  test "should include one gallery div" do
    assert_select 'div.gallery', 1
  end

  test "should render a picture within a gallery" do
    assert_select 'div.gallery > div.picture'
  end

  test "should render all the pictures" do
    assert_select 'div.gallery > div.picture', 2
  end

#-------------
  private

  def setup
    @pictures = Picture.find(:all)
    render :partial => 'pictures/gallery'
  end

end
