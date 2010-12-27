require 'test_helper'

class CookiesRequiredFilterApplicationControllerTest <
    SharedApplicationControllerTest

  test "when cookies (session store) are blocked..." do
    pretend_logged_in
    request.cookies.clear
# Should redirect:
    expect_sessions_new_redirect
    @controller.send :cookies_required
# Should log out:
    assert_blank session[:logged_in]
  end

end
