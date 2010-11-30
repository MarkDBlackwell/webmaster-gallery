require 'test_helper'

class ThumbnailPicturesPartialTest < SharedPicturesPartialTest

  test "should render pretty html source" do
    check_pretty_html_source nil, 'thumbnail'
  end

  test "thumbnail partial..." do
# Should render:
    assert_template :partial => 'pictures/_thumbnail', :count => 1
# There should be a single thumbnail div:
    assert_select 'div.thumbnail', 1
# There should be a single anchor, which should link to the right picture:
    assert_select 'div.thumbnail > a', 1
    assert_select 'a', 1 do
      assert_select '[href=?]', filename_matcher('two.png')
    end
# There should be a single image, which should have the right thumbnail
# filename source and the right title as alt-text:
    assert_select 'div.thumbnail > a > img', 1
    assert_select 'img', 1 do
      assert_select '[src=?]', filename_matcher('two-t.png')
      assert_select '[alt=?]', 'two-title'
    end
  end

#-------------
  private

  def setup
    picture=pictures(:two)
    render :partial => 'pictures/thumbnail', :locals => {:picture => picture}
  end

end
