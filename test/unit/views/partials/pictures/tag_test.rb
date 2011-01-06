require 'test_helper'

class TagPicturesPartialTest < SharedPicturesPartialTest

  test "happy path should render..." do
    happy_path
# The right partial, once:
    assert_partial
# Pretty html source:
    check_pretty_html_source nil, 'tag'
# A single...:
# Tag div, which should have the right css id:
    assert_select @dt, 1 do
      assert_select @iq, "tag_#{@tag.id}"
    end
# Anchor, which should link to the right tag:
    assert_select @dt.child(@a), 1
    assert_select @a, 1 do
      assert_select @hq, "/admin_pictures/#{@tag.name}"
    end
  end

  test "if tag is not a model record" do
    render_tag 'some-tag'
  end

#-------------
  private

  def happy_path
    render_tag tags :two
  end

  def setup
    @a, @d = %w[a  div].map{|e| CssString.new e}
    @hq, @iq = %w[href  id].map{|e| CssString.new.attribute e, '?'}
    @dt=@d.css_class 'tag'
  end

  def render_tag(t)
    @use_controller=:admin_pictures
    @tag=t
    render_partial 'pictures/tag', :tag => @tag
  end

end
