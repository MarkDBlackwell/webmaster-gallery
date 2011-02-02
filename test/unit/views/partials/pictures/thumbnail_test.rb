require 'test_helper'

class ThumbnailPicturesPartialTest < SharedPicturesPartialTest
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
  private

  def setup
    c=:pictures
    @controller.default_url_options={:controller=>c}
    picture=pictures :two
    touch_picture_files
    render_partial 'pictures/thumbnail', :picture => picture
    @a,@i = %w[a img]
    @d=CssString.new 'div'
    @dt=@d.css_class 'thumbnail'
  end

  def teardown
    @picture_files.each{|e| e.delete}
  end

  def touch_picture_files
    d=App.root.join *%w[public images gallery]
    p=@picture_files=[nil,'-t'].map{|e| d.join "two#{e}.png"}
    p.each{|e| FileUtils.touch e}
  end

end
