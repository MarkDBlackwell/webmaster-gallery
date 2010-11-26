require 'test_helper'

class SessionsControllerTest < SharedSessionsControllerTest

  ACTIONS=[:create, :destroy, :edit, :new, :show, :update]
  test_cookies_blocked ACTIONS
  test_if_not_logged_in_redirect_from  ACTIONS - [:create, :new]
  test_should_render_session_buttons ACTIONS - [:create,:destroy,:new,:update]
  test_wrong_http_methods ACTIONS

  test "guard logged in should skip some actions" do
    assert_filter :guard_logged_in, [:create,:destroy,:new]
  end

end
