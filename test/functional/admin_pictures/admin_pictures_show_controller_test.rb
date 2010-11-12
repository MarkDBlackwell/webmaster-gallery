require 'test_helper'

class AdminPicturesShowControllerTest < ActionController::TestCase
  tests AdminPicturesController

  test "should include this file" do
#    flunk
  end

  test "routing" do
    assert_routing({:path => '/admin_pictures/2', :method => 'get'},
        :controller => :admin_pictures.to_s, :action => :show.to_s, :id => '2')
  end

  test "should redirect to /session/new if not logged in" do
    session[:logged_in]=nil
    get :show, :id => '2'
    assert_redirected_to :controller => :sessions, :action => :new
  end

  test "happy path" do
    session[:logged_in]=true
    get :show, :id => pictures(:two).id
    assert_response :success
  end

  test "should render a single picture" do
# TODO: change to test that the pictures/picture partial was rendered once.
    session[:logged_in]=true
    get :show, :id => pictures(:two).id
    assert_select 'div.picture', 1
  end

  test "should render the right picture" do
# TODO: change to test that the pictures/picture partial was rendered with the locals for the right picture.
    session[:logged_in]=true
    id=pictures(:two).id
    get :show, :id => id
    assert_select "div.picture[id=picture_#{id}]"
  end

end
