require 'test_helper'

class GuardLoggedInFilterApplicationControllerTest <
    SharedApplicationControllerTest

  test "when not already logged in..." do
    session[:logged_in]=nil
# Should redirect:
    expect_sessions_new_redirect
    filter
  end

  test "when already logged in..." do
# Should not redirect:
    @controller.expects(:redirect_to).never
    filter
  end

#-------------
  private

  def setup
    @filter=:guard_logged_in
    pretend_logged_in
  end

end
