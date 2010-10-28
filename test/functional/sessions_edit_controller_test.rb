require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  include SessionsPrivateAllControllerTest

# Edit action tests:
# -> Webmaster reviews filesystem changes.

  test "routing for edit" do
    assert_routing({:path => '/session/edit', :method => :get},
      :controller => 'sessions', :action => 'edit')
  end

  test "should get edit" do
    session[:logged_in]=true
    get 'edit'
    assert_response :success
  end

  test "edit should redirect to new if not logged in" do
    session[:logged_in]=nil
    get 'edit'
    assert_redirected_to :action => 'new'
  end

  test "should edit if logged in" do
    session[:logged_in]=true
    get 'edit'
    assert_template 'edit'
  end

end
