require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  include SessionsPrivateAllControllerTest

# All actions tests:

  test "verify before_filters" do
    assert Date::today < Date::new(2010,10,29), 'Test unwritten.'
#    class SessionsController
#      before_filter :verify_authenticity_token
#    end
#    puts ActionController::Testing::ClassMethods.before_filters
  end

  test "should redirect to new on wrong method" do
    actions = [:create, :destroy, :edit, :new, :show, :update]
    should_redirect = {:action => :new}
    try_wrong_methods(actions, should_redirect, nil, nil)
  end

end
