require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  include SessionsPrivateAllControllerTest

# New action tests:
# -> Prompts webmaster to log in.

  test "should include this new file" do
#    flunk
  end

  test "routing for new" do
    assert_routing({:path => '/session/new', :method => :get},
      :controller => 'sessions', :action => 'new')
  end

  test "should new if not logged in" do
    session[:logged_in]=nil
    get :new
    assert_response :success
  end

  test "new should redirect to edit if already logged in" do
    session[:logged_in]=true
    get :new
    assert_redirected_to :action => :edit
  end

  test "new should flash if cookies (session store) blocked" do
    cookies={}
    get :new
    assert_equal 'Cookies required.', assigns(:cookies_blocked_error)
    assert_select 'div.cookies', 'Cookies required.'
  end

  test "new should not flash so, if cookies not blocked" do
    assert Date::today < Date::new(2010,11,9), 'Test unwritten.'
#    cookies[:something]='something'
#    get :new
#    see_output
#    assert_select 'div.cookies', 0
  end

  test "new should flash a notice if already logged in" do
    session[:logged_in]=true
    get :new
    assert_equal "You already were logged in.", flash[:notice]
  end

  test "new should clear the flash" do
    flash.now[:notice]='anything'
    flash[:notice]='anything'
    get :new
# TODO: assert nil or blank?
    assert_nil flash[:notice]
  end

  test "new should have one password form" do
    get :new
    assert_select 'form.password', 1
  end

  test "new should have one password form with method post" do
    get :new
    assert_select 'form.password[method=post]', 1
  end

  test "new should have one form with password field" do
    get :new
    assert_select 'form > input#password', 1
  end

  test "new should prompt for password" do
    get :new
    assert_select 'p', :count => 1, :text => "Type the password and hit 'Enter'."
  end

end
