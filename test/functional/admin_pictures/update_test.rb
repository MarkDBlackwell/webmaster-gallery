require 'test_helper'

class UpdateAdminPicturesControllerTest < SharedAdminPicturesControllerTest

  test_happy_path_response

  test "routing" do
    assert_routing({:path => '/admin_pictures/2', :method => :put},
        :controller => :admin_pictures.to_s, :action => :update.to_s,
        :id => '2')
  end

#-------------
  private

  def happy_path
    pretend_logged_in
    put :update, :id => pictures(:two).id
  end

end
