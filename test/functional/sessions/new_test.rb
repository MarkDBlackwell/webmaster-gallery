require 'test_helper'

class SessionsNewControllerTest < ActionController::TestCase
  include SessionsControllerTestShared
  tests SessionsController

# -> Prompts webmaster to log in.

  test "routing" do
    assert_routing({:path => '/session/new', :method => :get}, :controller =>
        :sessions.to_s, :action => :new.to_s)
  end

  test "happy path" do
    set_cookies
    get :new
    assert_response :success
  end

  test "should redirect to edit if already logged in" do
    pretend_logged_in
    get :new
    assert_redirected_to :action => :edit
  end

  test "should flash a notice if already logged in" do
    pretend_logged_in
    get :new
    assert_equal "You already were logged in.", flash[:notice]
  end

  test "should clear the flash" do
    flash.now[:notice]='anything'
    flash[:notice]='anything'
    set_cookies
    get :new
    assert_blank flash.now[:notice]
    assert_blank flash[:notice]
  end

  test "should suppress the session management buttons" do
    set_cookies
    get :new
    assert_equal true, assigns(:suppress_buttons)
  end

  test "should have one password form" do
    set_cookies
    get :new
    assert_select 'form.password', 1
  end

  test "should have one password form with method post" do
    set_cookies
    get :new
    assert_select 'form.password[method=post]', 1
  end

  test "should have one form with password field" do
    get :new
    assert_select 'form > input#password', 1
  end

  test "should prompt for password" do
    set_cookies
    get :new
    assert_select 'p', :count => 1, :text =>
        "Type the password and hit 'Enter'."
  end

end
