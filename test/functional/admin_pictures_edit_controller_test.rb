require 'test_helper'

class AdminPicturesEditControllerTest < ActionController::TestCase
  tests AdminPicturesController

  test "should include this file" do
#    flunk
  end

  test "routing" do
    assert_routing '/admin_pictures/2/edit', :controller => 'admin_pictures',
        :action => 'edit', :id => '2'
  end

  test "happy path" do
    session[:logged_in]=true
    get :edit, :id => pictures(:two).id
    assert_response :success
  end

  test "should redirect to /session/new if not logged in" do
    session[:logged_in]=nil
    get :edit, :id => pictures(:two).id
    assert_redirected_to :controller => :sessions, :action => :new
  end

  test "should render a picture" do
    session[:logged_in]=true
    get :edit, :id => pictures(:two).id
    assert_select 'div.picture'
  end

end
