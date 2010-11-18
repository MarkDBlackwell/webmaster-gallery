require 'test_helper'

class SessionsEditControllerTest < ActionController::TestCase
  include SessionsControllerTestShared
  tests SessionsController

# -> Webmaster reviews filesystem changes.

  test "routing" do
    assert_routing({:path => '/session/edit', :method => :get}, :controller =>
        :sessions.to_s, :action => :edit.to_s)
  end

  test "happy path" do
    pretend_logged_in
    get :edit
    assert_response :success
  end

  test "should redirect to new if not logged in" do
    set_cookies
    get :edit
    assert_redirected_to :action => :new
  end

  test "should render edit if logged in" do
    pretend_logged_in
    get :edit
    assert_template :edit
  end

end
