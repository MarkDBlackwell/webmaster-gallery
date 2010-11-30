require 'test_helper'

class GalleryPicturesPartialTest < SharedViewTest
  helper PicturesHelper

  test "should render pretty html source" do
    check_pretty_html_source 'Pictures',
        %w[ field gallery picture thumbnail ], 'form'
  end

  test "gallery partial..." do
# Should render:
    assert_template :partial => 'pictures/_gallery', :count => 1
# Should include one gallery div:
    assert_select 'div.gallery', 1
# Should render a picture within a gallery:
    assert_select 'div.gallery > div.picture'
# Should render all the pictures:
    assert_select 'div.gallery > div.picture', 2
  end

#-------------
  private

  def setup
    @pictures = Picture.find(:all)
    render :partial => 'pictures/gallery'
  end

end
