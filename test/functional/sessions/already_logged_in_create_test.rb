require 'test_helper'

class AlreadyLoggedInCreateSessionsControllerTest < SharedSessionsControllerTest

  test "when password wrong" do
    pretend_logged_in
    post :create, :password => 'example wrong password'
    assert_equal 'You already were logged in.', flash[:notice]
    assert_blank flash[:error]
  end

  test "when already logged in..." do
    pretend_logged_in
    post :create
# Should redirect to edit without asking password:
    assert_redirected_to :action => :edit
    assert_equal 'You already were logged in.', flash[:notice]
  end

end
