require 'test_helper'

class PicturesGalleryHelperTest < ActionView::TestCase
  include PicturesPrivateAllHelperTest
  tests PicturesHelper

  test "should include this file" do
#    flunk
  end

  test "should render partial" do
# TODO test "should render partial" do
    assert Date::today < Date::new(2010,11,12), 'Test unwritten.'
  end

  test "should render a gallery, once" do
    gallery
    assert_select 'div.gallery', 1
  end

end
