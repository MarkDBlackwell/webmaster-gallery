require 'test_helper'

class PicturesHelperTest < SharedPicturesHelperTest

  test "alert me when this works" do
    assert_raise StandardError do
      pictures(:all)
    end
  end

  test "should render pretty html source" do
# TODO: split up.
    render_all_tags
    render_all_pictures
    divs = %w[all-tags tag gallery picture thumbnail field edit]
    s = "<div class=\"#{Regexp.union *divs}\""
# Remove any of these divs which are at line beginnings:
    altered = rendered.gsub( Regexp.new("\n" + s),"\n")
    s2 = altered.clone
# Should not be able to find any of those divs:
    assert altered.gsub!(Regexp.new(s),'here').blank?, (see_output(s2);'Div class=')
  end

end