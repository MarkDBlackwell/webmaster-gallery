require 'test_helper'

class PicturesGalleryPartialTest < ActionView::TestCase
  helper PicturesHelper

  test "should render" do
    render_all_pictures
    assert_template :partial => 'pictures/_gallery'
  end

  test "should include one gallery div" do
    render_all_pictures
    assert_select 'div.gallery', 1
  end

  test "should render a picture within a gallery" do
    render_all_pictures
    assert_select 'div.gallery > div.picture'
  end

  test "should render all the pictures" do
    render_all_pictures
    assert_select 'div.gallery > div.picture', 2
  end

#-------------
  private

  def render_all_pictures
    @pictures = Picture.find(:all)
    render :partial => 'pictures/gallery'
  end

end
