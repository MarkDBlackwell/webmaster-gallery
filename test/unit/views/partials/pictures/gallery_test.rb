require 'test_helper'

class GalleryPicturesPartialTest < SharedPartialTest
  helper PicturesHelper

  test "happy path..." do
# Should render pretty html source:
    check_pretty_html_source 'Pictures',
        %w[ field  gallery  picture  thumbnail ], 'form'
# Should render:
    assert_partial
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
    render_partial 'pictures/gallery'
  end

end
