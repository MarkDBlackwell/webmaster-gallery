require 'test_helper'

class SessionsControllerTest < SharedSessionsControllerTest

#-------------
# Filter tests:

  test "filters" do
    assert_filter :cookies_required
    assert_filter :guard_http_method
    assert_filter_skips :guard_logged_in, [:create,:destroy,:new]
    assert_filter :verify_authenticity_token
  end

  ACTIONS=[:create, :destroy, :edit, :new, :show, :update]
  test_cookies_blocked ACTIONS

end
