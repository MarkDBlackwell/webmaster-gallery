require 'test_helper'

class AlreadyLoggedInCreateSessionsControllerTest < SharedSessionsControllerTest

  test "should redirect to edit without asking password" do
    pretend_logged_in
    post :create
    assert_redirected_to :action => :edit
  end

  test "should flash" do
    pretend_logged_in
    post :create
    assert_equal 'You already were logged in.', flash[:notice]
  end

  test "should not flash if password wrong" do
    pretend_logged_in
    post :create, :password => 'example wrong password'
    assert_blank flash[:error]
    assert_equal 'You already were logged in.', flash[:notice]
  end

end
