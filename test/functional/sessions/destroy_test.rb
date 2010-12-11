require 'test_helper'

class DestroySessionsControllerTest < SharedSessionsControllerTest

# <- Webmaster logs out.

#-------------
# General tests:

  test "routing" do # DELETE
    assert_routing({:path => '/session', :method => :delete}, :controller =>
      :sessions.to_s, :action => :destroy.to_s)
  end

  test "should remove the session cookie" do
# TODO  test "should remove the session cookie" do
    assert Date::today < Date::new(2010,12,24), 'Test unwritten.'
# Reference config/initializes/session_store.rb for cookie name.
  end

#-------------
# Not already logged in tests:

  test "when not already logged in..." do
    set_cookies
    delete :destroy
# Should flash a notice:
    assert_equal "You weren't logged in.", flash[:notice]
  end

#-------------
# Happy path tests:

  test_happy_path_response :new

  test "happy path..." do
    s=:something
    session[s]=s
    happy_path
# Should reset the session:
    assert_blank session[s]
# Should log out:
    assert_blank session[:logged_in]
# Should flash a notice:
    assert_equal 'Logged out successfully.', flash[:notice]
  end

#-------------
  private

  def happy_path
    pretend_logged_in
    delete :destroy
  end

end
