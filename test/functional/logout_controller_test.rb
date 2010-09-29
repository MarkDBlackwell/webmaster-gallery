require 'test_helper'

class LogoutControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "/logout should log out" do
    session[:logged_in]=true
    get :index
    assert_nil session[:logged_in]
  end
end
