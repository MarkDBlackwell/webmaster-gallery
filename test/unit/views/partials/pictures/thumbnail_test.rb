require 'test_helper'

class ThumbnailPicturesPartialTest < SharedPicturesPartialTest

  test "happy path..." do
# Should render pretty html source:
    check_pretty_html_source nil, 'thumbnail'
# Should render:
    assert_partial
# There should be a single thumbnail div:
    assert_select (s='div.thumbnail'), 1
# There should be a single anchor, which should link to the right picture:
    assert_select s+' > a', 1
    assert_select 'a', 1 do
      assert_select '[href=?]', (filename_matcher 'two.png')
    end
# There should be a single image, which should have the right thumbnail
# filename source and the right title as alt-text:
    assert_select s+' > a > img', 1
    assert_select 'img', 1 do
      assert_select '[src=?]', (filename_matcher 'two-t.png')
      assert_select '[alt=?]', 'two-title'
    end
  end

#-------------
  private

  def setup
    picture=pictures :two
    render_partial 'pictures/thumbnail', :picture => picture
  end

end
