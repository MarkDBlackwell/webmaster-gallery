require 'test_helper'

class IndexAdminPicturesControllerTest < SharedAdminPicturesControllerTest

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
    happy_path
    assert_response :success
  end

  test "should render the right template" do
    happy_path
    assert_template :index
# TODO: move to an alert test:
    assert_template :index, :count => 0
    assert_template :index, 0
  end

  test "should render a list of all tags, once" do
    happy_path
    assert_select 'div.all-tags', 1
    assert_template :partial => 'pictures/_all_tags', :count => 1
  end

  test "should render a gallery, once" do
    happy_path
    assert_select 'div.gallery', 1
    assert_template :partial => 'pictures/_gallery', :count => 1
  end

  test "pictures should be editable" do
    happy_path
    assert_present assigns(:editable)
  end

#-------------
  private

  def happy_path
    pretend_logged_in
    get :index
  end

end
