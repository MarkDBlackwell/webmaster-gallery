require 'test_helper'

class IndexAdminPicturesControllerTest < SharedAdminPicturesControllerTest

  test_happy_path_response

  test "routing" do
    assert_routing '/admin_pictures', :controller => :admin_pictures.to_s,
      :action => :index.to_s
  end

  test "routing with tag" do
    assert_routing '/admin_pictures/some_tag', :controller =>
        :admin_pictures.to_s, :action => :index.to_s, :tag => 'some_tag'
  end

  test "should render the right template" do
    happy_path
    assert_template :index
# TODO: move to an alert test:
    assert_template :index, :count => 0
    assert_template :index, 0
  end

  test "gallery pictures should be editable" do
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
