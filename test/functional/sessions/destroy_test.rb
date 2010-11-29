require 'test_helper'

class DestroySessionsControllerTest < SharedSessionsControllerTest

# <- Webmaster logs out.

  test_happy_path_response :new

  test "routing" do
    assert_routing({:path => '/session', :method => :delete}, :controller =>
      :sessions.to_s, :action => :destroy.to_s)
  end

  test "when not already logged in..." do
    set_cookies
    delete :destroy
# Should flash a notice:
    assert_equal "You weren't logged in.", flash[:notice]
  end

  test "happy path..." do
# Should reset the session:
    session[:something]='something'
    happy_path
    assert_blank session[:something]
# Should log out:
    assert_blank session[:logged_in]
# Should flash a notice:
    assert_equal 'Logged out successfully.', flash[:notice]
# Should redirect to new:
    assert_redirected_to :action => :new
  end

  test "should remove the session cookie" do
# TODO  test "should remove the session cookie" do
    assert Date::today < Date::new(2010,12,10), 'Test unwritten.'
# Reference config/initializes/session_store.rb for cookie name.
  end

#-------------
  private

  def happy_path
    pretend_logged_in
    delete :destroy
  end

end
