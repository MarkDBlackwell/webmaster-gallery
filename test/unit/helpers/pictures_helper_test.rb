require 'test_helper'
require File.expand_path('../pictures_private', __FILE__)

class PicturesHelperTest < ActionView::TestCase
  include PicturesHelperTestPrivate

  test "rake should include this file" do
#    flunk
  end

  test "all helpers should render pretty html source" do
    all_tags
    all_pictures
    divs = %w[all-tags tag gallery picture thumbnail title description year]
    s = "<div class=\"#{Regexp.union *divs}\""
# Remove any of these divs which are at line beginnings:
    altered = rendered.gsub( Regexp.new("\n" + s),"\n")
    s2 = altered.clone
# Should not be able to find any of those divs:
    assert_equal true, altered.gsub!(Regexp.new(s),'').nil?, s2
  end

end
