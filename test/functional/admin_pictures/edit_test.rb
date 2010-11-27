require 'test_helper'

class EditAdminPicturesControllerTest < SharedAdminPicturesControllerTest

  test_happy_path_response

  test "routing" do
    assert_routing '/admin_pictures/2/edit', :controller =>
        :admin_pictures.to_s, :action => :edit.to_s, :id => '2'
  end

#-------------
  private

  def happy_path
    pretend_logged_in
    get :edit, :id => pictures(:two).id
  end

end
