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
    assert_single [@dt,'id'], "tag_#{@tag.id}"
# Anchor, which should link to the right tag:
    assert_single [(@dt.child 'a'),'href'], '/admin_pictures/'+@tag.name
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
    @d=CssString.new 'div'
    @dt=@d.css_class 'tag'
  end

  def render_tag(t)
    @use_controller=:admin_pictures
    @tag=t
    render_partial 'pictures/tag', :tag => @tag
  end

end
