require 'test_helper'

class EditSessionsControllerTest < SharedSessionsControllerTest

# -> Webmaster reviews filesystem changes.

  test "routing" do
    assert_routing({:path => '/session/edit', :method => :get}, :controller =>
        :sessions.to_s, :action => :edit.to_s)
  end

  test_happy_path_response

  test_if_not_logged_in_redirect_from :edit

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
