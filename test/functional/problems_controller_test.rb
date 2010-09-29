require 'test_helper'

class ProblemsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should redirect to /login if not logged in" do
    session[:logged_in]=nil
    get :index
    assert_redirected_to :controller => "login", :action => "index"
  end

end
