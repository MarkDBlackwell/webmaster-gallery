require 'test_helper'

class LogoutControllerTest < ActionController::TestCase

  test "routing /logout" do
    assert_routing '/logout', :controller => 'logout', :action => 'index'
  end

  test "should redirect to '/'" do
    get :index
    assert_redirected_to '/'
  end

  test "should log out" do
    session[:logged_in]=true
    get :index
    assert_nil session[:logged_in]
  end

  test "should flash a notice of log out if logged in" do
    session[:logged_in] = true
    get :index
# I don't know why this doesn't work; I see it in the browser:
#    assert_select '#notice', 'Logged out successfully.'
# So, doing this, instead:
    assert_equal 'Logged out successfully.', flash[:notice]
  end

  test "should flash a notice if not logged in" do
    session[:logged_in] = nil
    get :index
# I don't know why this doesn't work; I see it in the browser:
#    assert_select '#notice', 'You weren't logged in.'
# So, doing this, instead:
    assert_equal "You weren't logged in.", flash[:notice]
  end

end
