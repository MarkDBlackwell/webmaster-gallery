require 'test_helper'

class DestroySessionsControllerTest < SharedSessionsControllerTest

# <- Webmaster logs out.
  test_happy_path_response :new

#-------------
# General tests:

  test "routing" do
    assert_routing({:path => '/session', :method => :delete}, :controller =>
      :sessions.to_s, :action => :destroy.to_s)
  end

  test "should reset the session" do
    happy_path
    assert_blank session[:something]
  end

  test "should remove the session cookie" do
# TODO  test "should remove the session cookie" do
    assert Date::today < Date::new(2010,12,10), 'Test unwritten.'
# Reference config/initializes/session_store.rb for cookie name.
  end

#-------------
# Not already logged in tests:

  test "should flash a notice if not already logged in" do
    set_cookies
    delete :destroy
    assert_equal "You weren't logged in.", flash[:notice]
  end

#-------------
# Logged-in tests:

  test "should redirect to new if logged in" do
    happy_path
    assert_redirected_to :action => :new
  end

  test "should log out if logged in" do
    happy_path
    assert_blank session[:logged_in]
  end

  test "should flash a notice of log out if logged in" do
    happy_path
    assert_equal 'Logged out successfully.', flash[:notice]
  end

#-------------
  private

  def happy_path
    pretend_logged_in
    delete :destroy
  end

end
