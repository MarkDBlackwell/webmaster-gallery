require 'test_helper'

class GuardHttpMethodFilterApplicationControllerTest <
    SharedApplicationControllerTest

  test "when wrong HTTP method..." do
# Ref: 'ActionController - PROPFIND and other HTTP request methods':
# at http://railsforum.com/viewtopic.php?id=30137
    request.expects(:request_method_symbol).at_least_once.returns :bad_method
# Should redirect:
    expect_sessions_new_redirect
# Should log out:
    filter
    assert_blank session[:logged_in]
  end

  test "when right HTTP method..." do
    filter
# Should not log out:
    assert_equal true, session[:logged_in]
  end

#-------------
  private

  def filter
    pretend_logged_in
    request.parameters[:action]='anything' # HTTP method defaults to 'get'.
    @filter=:guard_http_method
    super
  end

end
