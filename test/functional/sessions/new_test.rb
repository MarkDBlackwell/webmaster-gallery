require 'test_helper'

class NewSessionsControllerTest < SharedSessionsControllerTest

# -> Prompts webmaster to log in.
  test_happy_path_response

  test "routing" do
    assert_routing({:path => '/session/new', :method => :get}, :controller =>
        :sessions.to_s, :action => :new.to_s)
  end

  test "when cookies (session store) are blocked..." do
    pretend_logged_in
    request.cookies.clear
    get :new
    assert_template :new
# Log off:
    assert_blank session[:logged_in]
# Flash even if already logged in:
    assert_equal 'Cookies required, or session timed out.', flash.now[:error]
  end

  test "when already logged in..." do
    pretend_logged_in
    get :new
# Redirect:
    assert_redirected_to :action => :edit
    assert_equal "You already were logged in.", flash[:notice]
  end

  test "happy path..." do
    happy_path
# Should not flash:
    assert_blank flash.now[:notice]
    assert_blank flash.now[:error]
    assert_select 'div.notice', false
    assert_select 'div.error', false
# Suppress the session management buttons:
    assert_equal true, assigns(:suppress_buttons)
    assert_select 'div.session-buttons', 1
    assert_template :partial => 'application/_buttons', :count => 1
  end

#-------------
  private

  def happy_path
    set_cookies
    get :new
  end

end
