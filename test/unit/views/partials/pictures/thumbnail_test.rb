require 'test_helper'

class ThumbnailPicturesPartialTest < SharedPicturesPartialTest

  test "happy path should render..." do
# Pretty html source:
    check_pretty_html_source nil, 'thumbnail'
# The right partial, once:
    assert_partial
# A single...:
# Thumbnail div:
    assert_select @dt, 1
# Anchor, which should link to the right picture:
    assert_select @dt.child(@a), 1
    assert_select @a, 1 do
      assert_select @hq, (filename_matcher 'two.png')
    end
# Image, which should have the right thumbnail filename source and the right
# title as alt-text:
    assert_select @dt.child(@a,@i), 1
    assert_select @i, 1 do
      assert_select @sq, (filename_matcher 'two-t.png')
      assert_select @aq, 'two-title'
    end
  end

#-------------
  private

  def setup
    @use_controller=:admin_pictures
    picture=pictures :two
    touch_picture_files
    render_partial 'pictures/thumbnail', :picture => picture
    @a, @d, @i = %w[a  div  img].map{|e| CssString.new e}
    @aq, @hq, @sq = %w[alt href src].map{|e| CssString.new().attribute e, '?'}
    @dt=@d.css_class 'thumbnail'
  end

  def teardown
    @picture_files.each{|e| e.delete}
  end

  def touch_picture_files
    d=App.root.join *%w[public images gallery]
    (@picture_files=[nil,'-t'].map{|e| d.join "two#{e}.png"} ).
        map{|e| FileUtils.touch e}
  end

end
