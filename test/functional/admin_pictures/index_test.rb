require 'test_helper'

class AdminPicturesIndexControllerTest < ActionController::TestCase
  tests AdminPicturesController

  test "routing" do
    assert_routing '/admin_pictures', :controller => :admin_pictures.to_s,
      :action => :index.to_s
  end

  test "routing with tag" do
    assert_routing '/admin_pictures/some_tag', :controller =>
        :admin_pictures.to_s, :action => :index.to_s, :tag => 'some_tag'
  end

  test "should redirect to /session/new if not logged in" do
    set_cookies
    get :index
    assert_redirected_to :controller => :sessions, :action => :new
  end

  test "happy path" do
    pretend_logged_in
    get :index
    assert_response :success
  end

  test "should render the right template" do
    pretend_logged_in
    get :index
    assert_template :index
  end

  test "should render a list of all tags, once" do
    pretend_logged_in
    get :index
    assert_select 'div.all-tags', 1
    assert_template :partial => 'pictures/_all_tags', :count => 1
  end

  test "should render a gallery, once" do
    pretend_logged_in
    get :index
    assert_select 'div.gallery', 1
    assert_template :partial => 'pictures/_gallery', :count => 1
  end

  test "pictures should be editable" do
    pretend_logged_in
    get :index
    assert_present assigns(:editable)
  end

end
