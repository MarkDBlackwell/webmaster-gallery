require 'test_helper'

class VerifyAuthenticityTokenFilterApplicationControllerTest <
    SharedApplicationControllerTest
# %%co%%app%%filt

# Ref. http://railsforum.com/viewtopic.php?id=24298.
# The macro, 'protect_from_forgery' creates before-filter, ':verify_
# authenticity_token', which raises ActionController::InvalidAuthenticityToken.

# TODO: test "when authenticity token is invalid..." do
# How to test that the filter is invoked and raises the error?
# Perhaps not test this, since it is Rails software.
# Maybe alter the token in cookies.

  test "when authenticity token is valid, should..." do
# Not invoke handler:
    @controller.expects(:handle_bad_authenticity_token).never
    filter
# Not log out:
    assert_logged_in
  end

  test "when handle_bad_authenticity_token is invoked, should..." do
# Redirect:
    expect_redirect_sessions_new
    @controller.send :handle_bad_authenticity_token
# Log out:
    assert_not_logged_in
  end

#-------------
  private

  def setup
    @filter=:verify_authenticity_token
    pretend_logged_in
  end

end
