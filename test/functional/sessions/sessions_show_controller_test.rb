require 'test_helper'

class SessionsShowControllerTest < ActionController::TestCase
  include SessionsPrivateAllControllerTest
  tests SessionsController

# -> Webmaster reviews database problems.

#-------------
# General tests:

  test "should include this file" do
#    flunk
  end

  test "routing" do
    assert_routing({:path => '/session', :method => :get},
      :controller => 'sessions', :action => 'show')
  end

  test "happy path" do
    session[:logged_in]=true
    get 'show'
    assert_response :success
  end

  test "should redirect to new if not logged in" do
    session[:logged_in]=nil
    get 'show'
    assert_redirected_to :action => :new
  end

#-------------
# Already logged in tests:

# TODO: what should it show?

end
