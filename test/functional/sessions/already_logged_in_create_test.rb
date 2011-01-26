require 'test_helper'

class AlreadyLoggedInCreateSessionsControllerTest < SharedSessionsControllerTest
# %%co%%ses%%cr

  test "without password..." do
    post :create
    assert_flash_and_redirect
  end

  test "when password wrong..." do
    post :create, :password => 'example wrong password'
    assert_flash_and_redirect
  end

  test "when password right..." do
    login
    assert_flash_and_redirect
  end

#-------------
  private

  def assert_flash_and_redirect
# Should flash:
#    assert_equal 'You already were logged in.', flash[:notice]
    assert_blank flash[:error]
# Should redirect to edit:
#    assert_redirected_to :action => :edit
  end

  def setup
    pretend_logged_in
#    @controller.logger.expects(:warn).with 'W While session already logged '\
#        'in, login attempted from remote IP 0.0.0.0.'
    @controller.logger.expects(:warn).with \
        'W Authenticity-token (or cookie) security failure '\
        '(or program error): '\
        'while session already logged in, '\
        'login attempted from remote IP 0.0.0.0.'
  end

end
