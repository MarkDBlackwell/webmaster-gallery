require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  include SessionsPrivateAllControllerTest

# Destroy action tests:
# <- Webmaster logs out.

#-------------
# General tests:

  test "should include this destroy file" do
#    flunk
  end

  test "routing for destroy" do
    assert_routing({:path => '/session', :method => :delete},
      :controller => 'sessions', :action => 'destroy')
  end

  test "should destroy" do
    delete 'destroy'
    assert_response :redirect
  end

  test "destroy should reset the session" do
    session[:something] = true
    delete 'destroy'
    assert_nil session[:something]
  end

  test "destroy should remove the session cookie" do
    assert Date::today < Date::new(2010,11,7), 'Test unwritten.'
# Reference config/initializes/session_store.rb for cookie name.
  end

#-------------
# Not already logged in tests:

  test "destroy should flash a notice if not already logged in" do
    session[:logged_in]=nil
    delete 'destroy'
# I don't know why the following doesn't work; I see success in the browser:
#    assert_select '#notice', 'You weren't logged in.'
# So, doing this, instead:
    assert_equal "You weren't logged in.", flash[:notice]
  end

  test "destroy should redirect to new if not already logged in" do
    session[:logged_in]=nil
    delete 'destroy'
    assert_redirected_to :action => 'new'
  end

#-------------
# Logged-in tests:

  test "destroy should redirect to new if logged in" do
    session[:logged_in]=true
    delete 'destroy'
    assert_redirected_to :action => 'new'
  end

  test "destroy should log out if logged in" do
    session[:logged_in]=true
    delete 'destroy'
    assert_nil session[:logged_in]
  end

  test "destroy should flash a notice of log out if logged in" do
    session[:logged_in]=true
    delete 'destroy'
# I don't know why the following doesn't work; I see success in the browser:
#    assert_select '#notice', 'Logged out successfully.'
# So, doing this, instead:
    assert_equal 'Logged out successfully.', flash[:notice]
  end

end
