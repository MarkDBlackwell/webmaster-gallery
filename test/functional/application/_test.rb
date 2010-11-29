require 'test_helper'

class ApplicationControllerTest < SharedControllerTest

#-------------
# Configuration tests:

  test "sessions should expire after a duration of inactivity" do
    assert_nothing_raised do
      assert_equal 20.minutes, Gallery::Application.config.session_options.
          fetch(:expire_after)
    end
  end

  test "webmaster directory location should be configured" do
    assert_equal Gallery::Application.config.webmaster,
        "#{Rails.root}/test/fixtures/files/webmaster"
  end

#-------------
# Authenticity token tests:

  test "if authenticity token is invalid, should log out" do
# How to test filter, ':verify_authenticity_token'?
# TODO: Alter token in cookies.
    assert_logoff :invalid_authenticity_token
  end

#-------------
# Cookies tests:

  test "if cookies (session store) are blocked, should log out" do
    assert_logoff :cookies_required
  end

  test "if cookies (session store) are blocked, should render sessions/new" do
    @controller.expects(:render).with(:template => 'sessions/new')
# TODO: change to redirect. Only sessions/new should render with flash.now:
#    expect_sessions_new_redirect
    @controller.send :cookies_required
  end

#-------------
# HTTP methods tests:

  test "on right HTTP method, should not log out" do
    session[:logged_in]=true
    request.parameters[:action]='anything' # HTTP method defaults to 'get'.
    @controller.send :guard_http_method
    assert_equal true, session[:logged_in]
  end

  test "on wrong HTTP method, should log out" do
    request.parameters[:action]='anything'
    request.expects(:request_method_symbol).at_least_once.returns(:bad_method)
    assert_logoff :guard_http_method
  end

  test "on wrong HTTP method, should redirect to sessions new" do
    request.parameters[:action]=:index
    request.expects(:request_method_symbol).at_least_once.returns(:bad_method)
    expect_sessions_new_redirect
    @controller.send :guard_http_method
  end

#-------------
# Guard logged-in tests:

  test "if not logged in, should redirect to sessions new" do
    expect_sessions_new_redirect
    pretend_logged_in
    session[:logged_in]=nil
    @controller.send :guard_logged_in
  end

#-------------
  private

  def assert_logoff(filter)
    @controller.stubs :render
    @controller.stubs :redirect_to
    session[:logged_in]=true
    @controller.send filter
    assert_blank session[:logged_in]
  end

  def expect_sessions_new_redirect
    @controller.expects(:redirect_to).with(:controller => :sessions, :action =>
        :new)
  end

end
