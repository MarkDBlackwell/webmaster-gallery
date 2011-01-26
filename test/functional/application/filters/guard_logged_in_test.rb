require 'test_helper'

class GuardLoggedInFilterApplicationControllerTest <
    SharedApplicationControllerTest
# %%co%%app%%filt

  test "when not already logged in, should..." do
    session[:logged_in]=nil
# Redirect:
    expect_redirect_sessions_new
    filter
  end

  test "when already logged in, should..." do
# Not redirect:
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
