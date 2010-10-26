require 'test_helper'

class PicturesHelperTest < ActionView::TestCase

  test "gallery helper should render gallery partial" do
    assert Date::today < Date::new(2010,11,2), 'Test unwritten.'
# TODO: How to test this?
  end

  test "tags helper should render tags partial" do
    assert Date::today < Date::new(2010,11,2), 'Test unwritten.'
  end

end
