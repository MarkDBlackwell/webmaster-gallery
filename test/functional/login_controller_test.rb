require 'test_helper'

class LoginControllerTest < ActionController::TestCase

  test "routing /login" do
    assert_routing '/login', :controller => 'login', :action => 'index'
  end

  test "GET should get index if not logged in" do
    session[:logged_in]=nil
    get :index
    assert_response :success
  end

  test "GET should redirect to /logout if already logged in" do
    session[:logged_in]=true
    get :index
    assert_redirected_to '/logout'
  end

  test "POST should log in" do
    session[:logged_in]=nil
    post :index, :password => 'abc'
    assert_equal session[:logged_in], true
  end

  test "POST should redirect to /problems" do
    post :index, :password => 'abc'
    assert_redirected_to '/problems'
  end

  test "should have one form" do
    get :index
    assert_select "form", 1
  end

  test "should have one form with method POST" do
    get :index
    assert_select 'form[method=post]', 1
  end

  test "should have one form with password field" do
    get :index
    assert_select "form > input#password", 1
  end

  test "should prompt for password" do
    get :index
    assert_select "p", :count => 1, :text => "Type the password and hit 'Enter'"
  end

  test "should flash on wrong password entered" do
    post :index, :password => 'wrong example password'
    assert_select '#error', 'Password incorrect.'
  end

end
