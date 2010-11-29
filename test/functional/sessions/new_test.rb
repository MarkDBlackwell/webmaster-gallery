require 'test_helper'

class NewSessionsControllerTest < SharedSessionsControllerTest

# -> Prompts webmaster to log in.
  test_happy_path_response

  test "routing" do
    assert_routing({:path => '/session/new', :method => :get}, :controller =>
        :sessions.to_s, :action => :new.to_s)
  end

  test "should not flash if cookies not blocked" do
    happy_path
    assert_select 'div.notice', false
    assert_select 'div.error', false
  end

  test "should redirect to edit if already logged in" do
    pretend_logged_in
    get :new
    assert_redirected_to :action => :edit
  end

  test "should flash a notice if already logged in" do
    pretend_logged_in
    get :new
    assert_equal "You already were logged in.", flash[:notice]
  end

  test "should clear the flash" do
    k,v=:notice,'anything'
    flash.store(k,v)
    flash.now[k]=v
    happy_path
    assert_equal false, (flash.key? k)
    assert_blank flash.now[k]
  end

  test "should suppress the session management buttons" do
    happy_path
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
