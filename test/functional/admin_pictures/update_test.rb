require 'test_helper'

class UpdateAdminPicturesControllerTest < SharedAdminPicturesControllerTest

  test "routing" do # PUT
    assert_routing({:path => '/admin_pictures/2', :method => :put},
        :controller => :admin_pictures.to_s, :action => :update.to_s,
        :id => '2')
  end

  test_happy_path_response :show

#-------------
  private

  def happy_path
    pretend_logged_in
    put :update, :id => pictures(:two).id
  end

end
