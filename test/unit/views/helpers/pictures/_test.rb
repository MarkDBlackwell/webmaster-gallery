require 'test_helper'

class PicturesHelperTest < SharedPicturesHelperTest

  test "alert me when this works" do
    assert_raise StandardError do
      pictures(:all)
    end
  end

end
