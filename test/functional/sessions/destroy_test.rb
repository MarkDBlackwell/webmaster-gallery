require 'test_helper'
should_include_this_file

class SessionsDestroyControllerTest < ActionController::TestCase
  include SessionsControllerTestShared
  tests SessionsController

# <- Webmaster logs out.

#-------------
# General tests:

  test "routing" do
    assert_routing({:path => '/session', :method => :delete}, :controller =>
      :sessions.to_s, :action => :destroy.to_s)
  end

  test "happy path" do
    pretend_logged_in
    delete :destroy
    assert_response :redirect
  end

  test "should reset the session" do
    pretend_logged_in
    delete :destroy
    assert_blank session[:something]
  end

  test "should remove the session cookie" do
# TODO  test "should remove the session cookie" do
    assert Date::today < Date::new(2010,11,26), 'Test unwritten.'
# Reference config/initializes/session_store.rb for cookie name.
  end

#-------------
# Not already logged in tests:

  test "should flash a notice if not already logged in" do
    set_cookies
    delete :destroy
    assert_equal "You weren't logged in.", flash[:notice]
  end

  test "should redirect to new if not already logged in" do
    set_cookies
    delete :destroy
    assert_redirected_to :action => :new
  end

#-------------
# Logged-in tests:

  test "should redirect to new if logged in" do
    pretend_logged_in
    delete :destroy
    assert_redirected_to :action => :new
  end

  test "should log out if logged in" do
    pretend_logged_in
    delete :destroy
    assert_blank session[:logged_in]
  end

  test "should flash a notice of log out if logged in" do
    pretend_logged_in
    delete :destroy
    assert_equal 'Logged out successfully.', flash[:notice]
  end

end
