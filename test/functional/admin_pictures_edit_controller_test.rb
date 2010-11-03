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

  test "should redirect to /session/new if not logged in" do
    session[:logged_in]=nil
    get :edit, :id => '2'
    assert_redirected_to :controller => :sessions, :action => :new
  end

  test "happy path" do
    session[:logged_in]=true
    get :edit, :id => pictures(:two).id
    assert_response :success
  end

  test "should render a picture" do
    session[:logged_in]=true
    get :edit, :id => pictures(:two).id
    assert_select 'div.picture'
  end

  test "should render a single picture" do
    session[:logged_in]=true
    id=pictures(:two).id
    get :edit, :id => id
    assert_select 'div.picture', 1
  end

  test "should render the right picture" do
    session[:logged_in]=true
    id=pictures(:two).id
    get :edit, :id => id
    assert_select "div.picture[id=picture_#{id}]"
  end

  test "shouldn't display a picture commit button" do
    session[:logged_in]=true
    id=pictures(:two).id
    get :edit, :id => id
    style_include? 'div.picture > form > input[name=commit] '\
        '{display: none}'
  end

end
