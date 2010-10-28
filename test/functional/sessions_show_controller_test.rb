require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  include SessionsPrivateAllControllerTest

# Show action tests:
# -> Webmaster reviews database problems.

#-------------
# General tests:

  test "routing for show" do
    assert_routing({:path => '/session', :method => :get},
      :controller => 'sessions', :action => 'show')
  end

  test "should get show" do
    session[:logged_in]=true
    get 'show'
    assert_response :success
  end

  test "show should redirect to new if not logged in" do
    session[:logged_in]=nil
    get 'show'
    assert_redirected_to :action => 'new'
  end

#-------------
# Already logged in tests:

# TODO: what should it show?

end
