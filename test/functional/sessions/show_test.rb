require 'test_helper'

class ShowSessionsControllerTest < SharedSessionsControllerTest

# -> Webmaster reviews database problems.

#-------------
# General tests:

  test "routing" do
    assert_routing({:path => '/session', :method => :get}, :controller =>
        :sessions.to_s, :action => :show.to_s)
  end

  test "happy path" do
    happy_path
    assert_response :success
  end

  test "should redirect to new if not logged in" do
    set_cookies
    get :show
    assert_redirected_to :action => :new
  end

#-------------
# Already logged in tests:

# TODO: what should it show?

#-------------
  private

  def happy_path
    pretend_logged_in
    get :show
  end

end
