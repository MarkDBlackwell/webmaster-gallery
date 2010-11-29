require 'test_helper'

class AllControllerTest < ActionController::TestCase

  test "alert me..." do
# When Rails re-supports this controller test method:
    assert_raise NoMethodError do
      filter_chain()
    end
  end

end
