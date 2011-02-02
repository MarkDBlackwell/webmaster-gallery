require 'test_helper'

class TagPicturesPartialTest < SharedPicturesPartialTest
# %%vi%%part%%pic%%tag

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
    assert_single [(@dt.child 'a'),'href'], (@controller_url.join @tag.name)
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
    c=:pictures
    @controller.default_url_options={:controller=>c}
    @controller_url=Pathname('/').join c.to_s
    @d=CssString.new 'div'
    @dt=@d.css_class 'tag'
  end

  def render_tag(t)
    @tag=t
    render_partial 'pictures/tag', :tag => @tag
  end

end
