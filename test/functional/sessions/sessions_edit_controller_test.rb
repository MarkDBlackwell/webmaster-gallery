require 'test_helper'

class SessionsEditControllerTest < ActionController::TestCase
  include SessionsPrivateAllControllerTest
  tests SessionsController

# -> Webmaster reviews filesystem changes.

  test "should include this file" do
#    flunk
  end

  test "routing" do
    assert_routing({:path => '/session/edit', :method => :get},
      :controller => :sessions.to_s, :action => :edit.to_s)
  end

  test "happy path" do
    session[:logged_in]=true
    get :edit
    assert_response :success
  end

  test "should redirect to new if not logged in" do
    get :edit
    assert_redirected_to :action => :new
  end

  test "should render edit if logged in" do
    session[:logged_in]=true
    get :edit
    assert_template :edit
  end

end
