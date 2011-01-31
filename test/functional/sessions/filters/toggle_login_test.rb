require 'test_helper'

class ToggleLoginFilterSessionsControllerTest < SharedSessionsControllerTest
# %%co%%ses%%filt

  test "should..." do
    Square.new.each do |a,l|
      mocha_teardown
# (Expectations)...:
# Never redirect:
      @controller.expects(:redirect_to).never
      @controller.params['action'] = %w[create destroy].at a
      li=(session[:logged_in]=         [nil,   true   ].at l)
# When logged out creating, or logged in destroying (normal), should...:
      if l==a
# Not log a security warning:
        @controller.logger.expects(:warn).never
# Not respond with head only:
        @controller.expects(:head).never
# When logged in creating, or logged out destroying, should...:
      else
# Log a security warning:
        @controller.logger.expects(:warn).with token_message li
# Respond with head only, saying 'bad':
        @controller.expects(:head).with :bad_request
      end
      filter
# (Response)...:
# Always, should...:
# Not respond with a body:
      assert_blank @response.body
# Render nothing:
      assert_nothing_rendered
# Not flash:
      assert_flash_blank
# Not be logged in, now:
      assert_not_logged_in
# When logged in creating, or logged out destroying, should...:
      unless l==a
# Respond with head only, saying 'bad':
# This did not work:  assert_response :bad_request
      end
    end
  end

#-------------
  private

  def setup
    @filter=:toggle_login
  end

  def token_message(logged_in)
    "W Authenticity-token (or cookie) security failure "\
    "(or program error): "\
    "while session #{logged_in ? 'already':'not'} logged in"\
    ", login attempted from remote IP 0.0.0.0."
  end

end
