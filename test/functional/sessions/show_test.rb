require 'test_helper'

class ShowSessionsControllerTest < ActionController::TestCase
  include SessionsControllerTestShared
  tests SessionsController

# -> Webmaster reviews database problems.

#-------------
# General tests:

  test "routing" do
    assert_routing({:path => '/session', :method => :get}, :controller =>
        :sessions.to_s, :action => :show.to_s)
  end

  test "happy path" do
    pretend_logged_in
    get :show
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

end
