require 'test_helper'

class IndexAdminPicturesControllerTest < SharedAdminPicturesControllerTest

  test "routing..." do # GET
    assert_routing '/admin_pictures',
        :controller => :admin_pictures.to_s, :action => :index.to_s
# With tag:
    assert_routing '/admin_pictures/some_tag', :tag => 'some_tag',
        :controller => :admin_pictures.to_s, :action => :index.to_s
  end

  test_happy_path_response

  test "happy path..." do
    happy_path
# Should render the right template:
    assert_template :index
# Gallery pictures should be editable:
    assert_present assigns :editable
  end

#-------------
  private

  def happy_path
    pretend_logged_in
    get :index
  end

end
