require 'test_helper'

class AdminPicturesControllerTest < ActionController::TestCase

# All actions tests:

  test "verify before_filters" do
    assert Date::today < Date::new(2010,10,29), 'Test unwritten.'
#    class AdminPicturesController
#      before_filter :verify_authenticity_token
#    end
#    puts ActionController::Testing::ClassMethods.before_filters
  end

  test "should redirect to sessions new on wrong method" do
    actions = [:edit, :index, :show, :update]
    should_redirect = {:controller => :sessions, :action => :new}
    try_wrong_methods(actions, should_redirect, {:id => '2'},
        :logged_in => true)
  end

end
