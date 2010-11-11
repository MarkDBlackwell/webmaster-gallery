require 'test_helper'

class SessionsNewControllerTest < ActionController::TestCase
  include SessionsPrivateAllControllerTest
  tests SessionsController

# -> Prompts webmaster to log in.

  test "should include this file" do
#    flunk
  end

  test "routing" do
    assert_routing({:path => '/session/new', :method => :get},
      :controller => 'sessions', :action => 'new')
  end

  test "happy path" do
    session[:logged_in]=nil
    get :new
    assert_response :success
  end

  test "should redirect to edit if already logged in" do
    session[:logged_in]=true
    get :new
    assert_redirected_to :action => :edit
  end

  test "should flash a notice if already logged in" do
    session[:logged_in]=true
    get :new
    assert_equal "You already were logged in.", flash[:notice]
  end

  test "should clear the flash" do
    flash.now[:notice]='anything'
    flash[:notice]='anything'
    get :new
# TODO: assert nil or blank?
    assert_nil flash[:notice]
  end

  test "should suppress the buttons" do
    session[:logged_in] = nil
    get :new
    assert_equal true, assigns(:suppress_buttons)
  end

  test "should have one password form" do
    get :new
    assert_select 'form.password', 1
  end

  test "should have one password form with method post" do
    get :new
    assert_select 'form.password[method=post]', 1
  end

  test "should have one form with password field" do
    get :new
    assert_select 'form > input#password', 1
  end

  test "should prompt for password" do
    get :new
    assert_select 'p', :count => 1, :text => "Type the password and hit 'Enter'."
  end

end
