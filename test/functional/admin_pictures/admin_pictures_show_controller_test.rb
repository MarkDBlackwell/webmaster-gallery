require 'test_helper'

class AdminPicturesShowControllerTest < ActionController::TestCase
  tests AdminPicturesController

  test "should include this file" do
#    flunk
  end

  test "routing" do
    assert_routing({:path => '/admin_pictures/2', :method => :get},
        :controller => :admin_pictures.to_s, :action => :show.to_s, :id => '2')
  end

  test "should redirect to /session/new if not logged in" do
    get :show, :id => '2'
    assert_redirected_to :controller => :sessions, :action => :new
  end

  test "happy path" do
    session[:logged_in]=true
    get :show, :id => pictures(:two).id
    assert_response :success
  end

  test "should render a single picture" do
    session[:logged_in]=true
    get :show, :id => pictures(:two).id
    assert_select 'div.picture', 1
    assert_template :partial => 'pictures/_picture', :count => 1
  end

  test "should render the right picture" do
    picture=pictures(:two)
    id=picture.id
    session[:logged_in]=true
    get :show, :id => id
    assert_select "div.picture[id=picture_#{id}]"
# TODO: change to test that the pictures/picture partial was rendered with the locals for the right picture.
# Did not work:
#    assert_template :partial => 'pictures/_picture', :locals => {:picture =>
#        picture}
  end

end
