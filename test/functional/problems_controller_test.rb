require 'test_helper'

class ProblemsControllerTest < ActionController::TestCase
  test "routing /problems" do
    assert_routing '/problems', :controller => 'problems', :action => 'index'
  end

  test "should get index" do
    session[:logged_in]=true
    get :index
    assert_response :success
  end

  test "should redirect to /login if not logged in" do
    session[:logged_in]=nil
    get :index
    assert_redirected_to '/login'
  end

end
