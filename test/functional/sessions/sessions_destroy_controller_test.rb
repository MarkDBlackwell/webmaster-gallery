require 'test_helper'

class SessionsDestroyControllerTest < ActionController::TestCase
  include SessionsPrivateAllControllerTest
  tests SessionsController

# <- Webmaster logs out.

#-------------
# General tests:

  test "should include this file" do
#    flunk
  end

  test "routing" do
    assert_routing({:path => '/session', :method => :delete},
      :controller => 'sessions', :action => 'destroy')
  end

  test "happy path" do
    delete :destroy
    assert_response :redirect
  end

  test "should reset the session" do
    session[:something] = true
    delete :destroy
    assert_nil session[:something]
  end

  test "should remove the session cookie" do
# TODO  test "should remove the session cookie" do
    assert Date::today < Date::new(2010,11,7), 'Test unwritten.'
# Reference config/initializes/session_store.rb for cookie name.
  end

#-------------
# Not already logged in tests:

  test "should flash a notice if not already logged in" do
    session[:logged_in]=nil
    delete :destroy
    assert_equal "You weren't logged in.", flash[:notice]
  end

  test "should redirect to new if not already logged in" do
    session[:logged_in]=nil
    delete :destroy
    assert_redirected_to :action => 'new'
  end

#-------------
# Logged-in tests:

  test "should redirect to new if logged in" do
    session[:logged_in]=true
    delete :destroy
    assert_redirected_to :action => 'new'
  end

  test "should log out if logged in" do
    session[:logged_in]=true
    delete :destroy
    assert_nil session[:logged_in]
  end

  test "should flash a notice of log out if logged in" do
    session[:logged_in]=true
    delete :destroy
    assert_equal 'Logged out successfully.', flash[:notice]
  end

end