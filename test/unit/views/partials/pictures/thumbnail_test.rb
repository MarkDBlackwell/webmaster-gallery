require 'test_helper'

class ThumbnailPicturesPartialTest < SharedPartialTest
# %%vi%%part%%pic%%th

  test "happy path should render..." do
# Pretty html source:
    check_pretty_html_source nil, 'thumbnail'
# The right partial, once:
    assert_partial
# A single...:
# Thumbnail div:
    assert_select @dt, 1
# Anchor, which should...:
    assert_select @dt.child(@a), 1
# Link to the right picture:

## base_uri
## gallery_directory
## gallery_uri

    assert_single [@a,'href'], (filename_matcher 'two.png')
# Open in a new window:
    assert_single [@a,'target'], '_blank'
# And...:
# A single...:
# Image, which should have the right...
    assert_select @dt.child(@a,@i), 1
# Thumbnail filename source:
    assert_single [@i,'src'], (filename_matcher 'two-t.png')
# Title as alt-text:
    assert_single [@i,'alt'], 'two-title'
  end

#-------------

  def setup
    c=:pictures
    @controller.default_url_options={:controller=>c}
    picture=pictures :two
    touch_picture_files [nil,'-t'].map{|e| "two#{e}.png"}
    render_partial 'pictures/thumbnail', :picture => picture
    @a,@i = %w[a img]
    @d=CssString.new 'div'
    @dt=@d.css_class 'thumbnail'
  end

  def teardown
    delete_picture_files
  end

end
