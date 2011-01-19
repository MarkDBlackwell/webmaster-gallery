require 'test_helper'

class GalleryPicturesPartialTest < SharedPartialTest
# %%vi%%part%%pic%%gal

  helper PicturesHelper

  test "happy path should render..." do
# Pretty html source:
    check_pretty_html_source 'Pictures',
        %w[ field  gallery  picture  thumbnail ], 'form'
# The right partial, once:
    assert_partial
# One gallery div:
    assert_select @dg, 1
# All the pictures within the gallery:
    assert_select @dg.child('div').css_class('picture'), 2
  end

#-------------
  private

  def setup
    @use_controller=:admin_pictures
    @pictures=Picture.find :all
    render_partial 'pictures/gallery'
    @dg=CssString.new('div').css_class 'gallery'
  end

end
