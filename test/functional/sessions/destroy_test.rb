require 'test_helper'

class DestroySessionsControllerTest < SharedSessionsControllerTest
# %%co%%ses%%de

# <- Webmaster logs out.

#-------------
# General tests:

  test "routing" do # DELETE
    assert_routing({:path => '/session', :method => :delete}, :controller =>
      :sessions.to_s, :action => :destroy.to_s)
  end

  test "should remove the session cookie" do
# TODO  test "should remove the session cookie" do
# Ref. config/initializers/session_store.rb for cookie name.
    assert Date::today < Date::new(2011,2,3), 'Test unwritten.'
  end

#-------------
# Not already logged in tests:

  test "when not already logged in, should..." do
    set_cookies
    delete :destroy
# Redirect to new:
    assert_redirected_to :action => :new
# Should flash a notice:
    assert_equal "You weren't logged in.", flash[:notice]
# Should still be logged out:
    assert_not_logged_in
  end

#-------------
# Happy path tests:

  test_happy_path_response :new

  test "happy path..." do
    kv=:something
    session[kv]=kv
    happy_path
# Should reset the session:
    assert_blank session[kv]
# Should flash a notice:
    assert_equal 'Logged out successfully.', flash[:notice]
# Should log out:
    assert_not_logged_in
  end

#-------------
  private

  def happy_path
    pretend_logged_in
    delete :destroy
  end

end
