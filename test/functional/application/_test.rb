require 'test_helper'

class ApplicationControllerTest < SharedControllerTest

#-------------
# Configuration tests:

  test "sessions should expire after a duration of inactivity" do
    assert_equal 20.minutes, App.session_options.fetch(:expire_after)
  end

  test "webmaster directory location should be configured" do
    assert_equal App.webmaster,
        (App.root.join *%w[test fixtures files webmaster])
  end

#-------------
# Verify_authenticity_token filter tests:

  test "when authenticity token is invalid..." do
# How to test filter, ':verify_authenticity_token'?
# TODO: Alter token in cookies.
    pretend_logged_in
# Should redirect:
    expect_sessions_new_redirect
    @controller.send :invalid_authenticity_token
# Should log out:
    assert_blank session[:logged_in]
  end

#-------------
# Cookies_required filter tests:

  test "when cookies (session store) are blocked..." do
    pretend_logged_in
    request.cookies.clear
# Should redirect:
    expect_sessions_new_redirect
    @controller.send :cookies_required
# Should log out:
    assert_blank session[:logged_in]
  end

#-------------
# Guard_http_method filter tests:

  test "when wrong HTTP method..." do
    pretend_logged_in
    action_anything
    bad_method
# Should redirect:
    expect_sessions_new_redirect
    @controller.send :guard_http_method
# Should log out:
    assert_blank session[:logged_in]
  end

  test "when right HTTP method..." do
    pretend_logged_in
    action_anything
    @controller.send :guard_http_method
# Should not log out:
    assert_equal true, session[:logged_in]
  end

#-------------
# Guard_logged_in filter tests:

  test "when not already logged in..." do
    pretend_logged_in
    session[:logged_in]=nil
# Should redirect:
    expect_sessions_new_redirect
    @controller.send :guard_logged_in
  end

#-------------
  private

  def action_anything
    request.parameters[:action]='anything' # HTTP method defaults to 'get'.
  end

  def bad_method
    request.expects(:request_method_symbol).at_least_once.returns(:bad_method)
  end

  def expect_sessions_new_redirect
    @controller.expects(:redirect_to).with(:controller => :sessions, :action =>
        :new)
  end

end
