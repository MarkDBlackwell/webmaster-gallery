require 'test_helper'

class AdminPicturesShowControllerTest < ActionController::TestCase
  tests AdminPicturesController

  test "should include this file" do
#    flunk
  end

  test "routing" do
    assert_routing({:path => '/admin_pictures/2', :method => 'get'},
        :controller => 'admin_pictures', :action => 'show', :id => '2')
  end

  test "happy path" do
    session[:logged_in]=true
    get :show, :id => '2'
    assert_response :success
  end

  test "should redirect to /session/new if not logged in" do
    session[:logged_in]=nil
    get :show, :id => '2'
    assert_redirected_to :controller => :sessions, :action => :new
  end

end
