require 'test_helper'

class EditSessionsControllerTest < SharedSessionsControllerTest

# -> Webmaster reviews filesystem changes.

  test "routing" do
    assert_routing({:path => '/session/edit', :method => :get}, :controller =>
        :sessions.to_s, :action => :edit.to_s)
  end

  test "happy path" do
    happy_path
    assert_response :success
  end

  test "should redirect to new if not logged in" do
    set_cookies
    get :edit
    assert_redirected_to :action => :new
  end

  test "should render edit if logged in" do
    happy_path
    assert_template :edit
  end

#-------------
  private

  def happy_path
    pretend_logged_in
    get :edit
  end

end
