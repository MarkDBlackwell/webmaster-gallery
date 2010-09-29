require 'test_helper'

class LoginControllerTest < ActionController::TestCase

  test "routing '/login'" do
    assert_routing '/login', :controller => 'login', :action => 'index'
  end

  test "should get index" do
    get :index
    assert_response :success
  end

end
