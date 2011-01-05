require 'test_helper'

class VerifyAuthenticityTokenFilterApplicationControllerTest <
    SharedApplicationControllerTest

# Ref. http://railsforum.com/viewtopic.php?id=24298.
# The macro, 'protect_from_forgery' creates before-filter, ':verify_
# authenticity_token', which raises ActionController::InvalidAuthenticityToken.

# TODO: test "when authenticity token is invalid..." do
# How to test that the filter is invoked and raises the error?
# Perhaps not test this, since it is Rails software.
# Maybe alter the token in cookies.
#  end


  test "when authenticity token is valid..." do
# Should not invoke handler:
    @controller.expects(:handle_bad_authenticity_token).never
    filter
# Should not log out:
    assert_logged_in
  end

  test "when handle_bad_authenticity_token is invoked..." do
# Should redirect:
    expect_redirect_sessions_new
    @controller.send :handle_bad_authenticity_token
# Should log out:
    assert_not_logged_in
  end

#-------------
  private

  def setup
    @filter=:verify_authenticity_token
    pretend_logged_in
  end

end
