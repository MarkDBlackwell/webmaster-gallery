require 'test_helper'

class AllControllerTest < ActionController::TestCase
# %%co

  test "alert me..." do
# When Rails re-supports this controller test method:
    assert_raise(NoMethodError){filter_chain()}
  end

end
