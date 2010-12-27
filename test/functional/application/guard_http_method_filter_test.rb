require 'test_helper'

class GuardHttpMethodFilterApplicationControllerTest <
    SharedApplicationControllerTest

# Ref: 'ActionController - PROPFIND and other HTTP request methods':
# at http://railsforum.com/viewtopic.php?id=30137

  test "when wrong HTTP method..." do
    request.expects(:request_method_symbol).at_least_once.returns :bad_method
# Should redirect:
    expect_sessions_new_redirect
    filter
# Should log out:
    assert_not_logged_in
  end

  test "when right HTTP method..." do
    filter
# Should not log out:
    assert_logged_in
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
