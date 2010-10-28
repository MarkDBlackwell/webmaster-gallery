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
    try_wrong_methods(actions)
  end

  test "get actions should include manage-session div" do
    %w[edit new show].each do |action|
      session[:logged_in] = 'new' == action ? nil : true
      get action
      assert_select 'div.manage-session', 1, "Action #{action}"
    end
  end
end
