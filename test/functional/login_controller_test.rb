require 'test_helper'

class LoginControllerTest < ActionController::TestCase

  test "routing '/login'" do
    assert_routing '/login', :controller => 'login', :action => 'index'
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "/login should log in" do
    session[:logged_in]=nil
    get :index, :password => "abc"
    assert_equal session[:logged_in], true
  end
end
