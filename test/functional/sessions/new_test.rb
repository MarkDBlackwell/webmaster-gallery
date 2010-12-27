require 'test_helper'

class NewSessionsControllerTest < SharedSessionsControllerTest

# -> Prompts webmaster to log in.

  test "routing" do # GET
    assert_routing({:path => '/session/new', :method => :get}, :controller =>
        :sessions.to_s, :action => :new.to_s)
  end

  test "when cookies (session store) are blocked, even if already logged"\
       " in..." do
    pretend_logged_in
    request.cookies.clear
    get :new
# Should render new:
    assert_template :new
# Should flash:
    assert_equal 'Cookies required, or session timed out.', flash.now[:error]
# Should log out:
    assert_not_logged_in
  end

  test "when already logged in..." do
    pretend_logged_in
    get :new
# Should flash:
    assert_equal "You already were logged in.", flash[:notice]
# Should redirect:
    assert_redirected_to :action => :edit
# Should not log out:
    assert_logged_in
  end

  test_happy_path_response

  test "happy path..." do
    happy_path
# Should render the right template:
    assert_template :new
# Should suppress the session management buttons:
    assert_equal true, (assigns :suppress_buttons)
# Should not flash:
    assert_blank flash.now[:notice]
    assert_blank flash.now[:error]
# Should not log in:
    assert_not_logged_in
  end

#-------------
  private

  def happy_path
    set_cookies
    get :new
  end

end
