require 'test_helper'

class GuardHttpMethodFilterApplicationControllerTest <
    SharedApplicationControllerTest

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
  private

  def action_anything
    request.parameters[:action]='anything' # HTTP method defaults to 'get'.
  end

  def bad_method
    request.expects(:request_method_symbol).at_least_once.returns :bad_method
  end

end
