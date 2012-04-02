require 'test_helper'

class CookiesRequiredFilterApplicationControllerTest <
    SharedApplicationControllerTest
# %%co%%app%%filt

  test "when cookies (session store) are blocked (in sessions/new), even if "\
       "already logged in, should..." do
    request.cookies.clear
    %w[controller action].zip(%w[sessions new]).each{|k,v| @controller.params[
        k]=v}
# Not redirect:
    @controller.expects(:redirect_to).never
    filter
    assert_nothing_rendered
# Flash:
    assert_equal @message, flash.now[:error]
# Log out:
    assert_not_logged_in
  end

  test "when cookies (session store) are blocked (in other actions), should"\
       "..." do
    request.cookies.clear
# Redirect:
    expect_redirect_sessions_new
    filter
# Flash:
    assert_equal @message, flash[:error]
# Log out:
    assert_not_logged_in
  end

  test "when have cookies, should..." do
    filter
# Not log out:
    assert_logged_in
  end

#-------------

  def setup
    @filter = :cookies_required
    @message= 'Cookies required (or timeout).'
    pretend_logged_in # Keep before clearing by the filter.
  end

end
