require 'test_helper'

class VerifyAuthenticityTokenFilterApplicationControllerTest <
    SharedApplicationControllerTest

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

end
