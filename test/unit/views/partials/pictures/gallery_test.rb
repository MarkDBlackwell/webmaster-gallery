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
    assert_select (s1='div.gallery'), 1
# Should render a picture within a gallery:
    assert_select (s2=s1+' > div.picture')
# Should render all the pictures:
    assert_select s2, 2
  end

#-------------
  private

  def setup
    @pictures=Picture.find :all
    render_partial 'pictures/gallery'
  end

end
