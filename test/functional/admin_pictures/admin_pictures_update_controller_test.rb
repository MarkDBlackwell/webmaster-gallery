require 'test_helper'

class AdminPicturesUpdateControllerTest < ActionController::TestCase
  tests AdminPicturesController

  test "should include this file" do
#    flunk
  end

  test "routing" do
    assert_routing({:path => '/admin_pictures/2', :method => :put},
        :controller => :admin_pictures.to_s, :action => :update.to_s,
        :id => '2')
  end

  test "should redirect to /session/new if not logged in" do
    put :update, :id => '2'
    assert_redirected_to :controller => :sessions, :action => :new
  end

  test "happy path" do
    session[:logged_in]=true
    put :update, :id => pictures(:two).id
    assert_response :success
  end

end
