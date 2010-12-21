require 'test_helper'

class ApplicationControllerTest < SharedControllerTest

#-------------
# Configuration tests:

  test "sessions should expire after a duration of inactivity" do
    assert_equal 20.minutes, App.session_options.fetch(:expire_after)
  end

  test "webmaster directory location should be configured" do
    assert_equal App.webmaster, App.root.join(
        *%w[test  fixtures  files  webmaster])
  end

#-------------
# Filter tests:

  test "filters" do
    assert_no_filter :avoid_links
    assert_filter    :cookies_required
    assert_filter    :find_all_tags
    assert_no_filter :get_single
    assert_filter    :guard_http_method
    assert_filter    :guard_logged_in
    assert_filter    :verify_authenticity_token
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
# Find_all_tags filter tests:

  test "find_all_tags filter should..." do
    @controller.send :find_all_tags
# Assign an instance variable for all the tags.
    assert_equal Tag.find(:all), assigns(:all_tags)
  end

#-------------
# Guard_http_method filter tests:

  test "when wrong HTTP method..." do
# Ref: 'ActionController - PROPFIND and other HTTP request methods':
# at http://railsforum.com/viewtopic.php?id=30137
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
# Verify_authenticity_token filter tests:

# TODO: test "when authenticity token is invalid..." do
# Ref. http://railsforum.com/viewtopic.php?id=24298.
# The macro, 'protect_from_forgery' creates before-filter, ':verify_
# authenticity_token', which raises ActionController::InvalidAuthenticityToken.
# How to test that the filter is invoked and raises the error?
# Perhaps not test this, since it is Rails software.
# Maybe alter the token in cookies.
#  end

  test "when handle_bad_authenticity_token is invoked..." do
    pretend_logged_in
# Should redirect:
    expect_sessions_new_redirect
    @controller.send :handle_bad_authenticity_token
# Should log out:
    assert_blank session[:logged_in]
  end

#-------------
  private

  def action_anything
    request.parameters[:action]='anything' # HTTP method defaults to 'get'.
  end

  def bad_method
    request.expects(:request_method_symbol).at_least_once.returns :bad_method
  end

  def expect_sessions_new_redirect
    @controller.expects(:redirect_to).with :controller => :sessions, :action =>
        :new
  end

end
