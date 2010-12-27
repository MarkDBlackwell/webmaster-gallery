require 'test_helper'

class CookiesRequiredFilterApplicationControllerTest <
    SharedApplicationControllerTest

  test "when cookies (session store) are blocked..." do
    request.cookies.clear
# Should redirect:
    expect_sessions_new_redirect
# Should log out:
    filter
    assert_blank session[:logged_in]
  end

  test "when have cookies" do
    filter
# Should not log out:
    assert_equal true, session[:logged_in]
  end

#-------------
  private

  def setup
    @filter=:cookies_required
    pretend_logged_in # Keep before clearing.
  end

end
