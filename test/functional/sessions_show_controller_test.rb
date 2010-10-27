require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  include SessionsPrivateAllControllerTest

# Show action tests:
# -> Webmaster reviews database problems.

  test "routing for show" do
    assert_routing({:path => '/session', :method => :get},
      :controller => 'sessions', :action => 'show')
  end

  test "should show" do
    get :show
    assert_response :success
  end

end
