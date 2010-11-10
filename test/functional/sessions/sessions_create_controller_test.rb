require 'test_helper'

class SessionsCreateControllerTest < ActionController::TestCase
  include SessionsPrivateAllControllerTest
  tests SessionsController

# <- Webmaster logs in.

#-------------
# General tests:

  test "should include this file" do
#    flunk
  end

  test "routing" do
    assert_routing({:path => '/session', :method => :post},
      :controller => 'sessions', :action => 'create')
  end

  test "happy path" do
    login
    assert_redirected_to :action => :edit
  end

  test "should reset the session" do
    session[:something]='something'
    post 'create'
    assert_nil session[:something]
  end

  test "how to test should handle invalid authenticity token?" do
# TODO  test "how to test should handle invalid authenticity token?" do
    assert Date::today < Date::new(2010,11,15), 'Test unwritten.'
# Doesn't get rescued by application controller:
#    raise ActionController::InvalidAuthenticityToken
# Try to POST with invalid authenticity token.
#    post 'create', :try_this => 'hello'
#    assert_equal 'hello', params[:try_this]
# Didn't find 'config':
#    config.action_controller.allow_forgery_protection = true
# Try re-raising exceptions.
#    puts LoginController.inspect
#    class LoginController;def rescue_action(e);raise e;end;end
# See params and session.
#    post 'create', {:try_this => 'in params'}, {:try_this => 'in session'}
#    puts response
#    puts response.methods.sort
#    puts request.session
#    post 'create'
#    session[:try_this]='hello'
#    puts session.sort
#    assigns["try_this"]='in assigns'
#    puts assigns(:try_this)
#    request.session[:authenticity_token]
  end

  test "should log in" do
    session[:logged_in]=nil
    login
    assert_equal true, session[:logged_in]
  end

  test "should flash if cookies (session store) blocked" do
    request.cookies.clear
    post 'create'
    assert_select 'div.error', 'Cookies required, or session timed out.'
  end

  test "should not flash so, if cookies not blocked" do
    login
    assert_select 'div.notice', 0
    assert_select 'div.error', 0
  end

  test "shouldn't make a pictures layout file" do
    login
    assert_equal false, pictures_in_layouts_directory?
  end

  test "shouldn't read the webmaster page file" do
    fn="#{Gallery::Application.config.webmaster}/page.html.erb"
    remove_read_permission(fn) {login}
  end

#-------------
# Wrong password, not already logged in tests:

  test "should redirect to new on wrong password if not already logged in" do
    session[:logged_in]=nil
    login 'example wrong password'
    assert_redirected_to :action => :new
  end

  test "should flash on wrong password if not already logged in" do
    session[:logged_in]=nil
    login 'example wrong password'
    assert_equal 'Password incorrect.', flash[:error]
  end

#-------------
# Right password, not already logged in tests:

  test "should redirect to edit on right password if not already logged in" do
    session[:logged_in]=nil
    login
    assert_redirected_to :action => :edit
  end

#-------------
# Already logged in tests:

  test "should redirect to edit without asking password if already logged in" do
    session[:logged_in]=true
    post 'create'
    assert_redirected_to :action => :edit
  end

  test "should flash so, when already logged in" do
    session[:logged_in]=true
    post 'create'
    assert_equal 'You already were logged in.', flash[:notice]
  end

  test "should not flash on wrong password when already logged in" do
    session[:logged_in]=true
    post 'create', :password => 'example wrong password'
    assert_equal 'You already were logged in.', flash[:notice]
    assert_blank flash[:error]
  end

end
