require 'test_helper'

class GuardLoggedInFilterApplicationControllerTest <
    SharedApplicationControllerTest

  test "when not already logged in..." do
    pretend_logged_in
    session[:logged_in]=nil
# Should redirect:
    expect_sessions_new_redirect
    @controller.send :guard_logged_in
  end

end
