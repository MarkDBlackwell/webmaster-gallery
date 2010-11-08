require 'test_helper'

class AdminPicturesIndexControllerTest < ActionController::TestCase
  tests AdminPicturesController

  test "should include this file" do
#    flunk
  end

  test "routing" do
    assert_routing '/admin_pictures', :controller => 'admin_pictures',
      :action => 'index'
  end

  test "routing with tag" do
    assert_routing '/admin_pictures/some_tag',
      :controller => 'admin_pictures', :action => 'index', :tag => 'some_tag'
  end

  test "should redirect to /session/new if not logged in" do
    session[:logged_in]=nil
    get :index
    assert_redirected_to :controller => :sessions, :action => :new
  end

  test "happy path" do
    session[:logged_in]=true
    get :index
    assert_response :success
  end

  test "should render the right template" do
# TODO  test "should render the right template" do
    assert Date::today < Date::new(2010,11,15), 'Test unwritten.'
#    session[:logged_in]=true
#    get :index
#    list = ['gallery','picture','all_tags'].collect do |e|
#        ['','pictures/'].collect {|prefix| "#{prefix}_#{e}"}
#    end.flatten!
#    list = ['_picture','pictures/_gallery','_all_tags','pictures/_picture',
#       '_gallery','pictures/_all_tags']
#puts list
#    assert_template :controller => :admin_pictures, :action => :index,
#        :partial => list
  end

  test "should render a list of all tags, once" do
# TODO: change to test that the pictures/all_tags partial was rendered once.
    session[:logged_in]=true
    get :index
    assert_select 'div.all-tags', 1
  end

  test "should render a gallery, once" do
# TODO: change to test that the pictures/gallery partial was rendered with the right locals.
    session[:logged_in]=true
    get :index
    assert_select 'div.gallery', 1
  end

  test "pictures should be editable" do
    session[:logged_in]=true
    get :index
    assert_not_nil assigns(:editable)
  end

end
