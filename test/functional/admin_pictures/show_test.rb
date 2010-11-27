require 'test_helper'

class ShowAdminPicturesControllerTest < SharedAdminPicturesControllerTest

  test_happy_path_response

  test "routing" do
    assert_routing({:path => '/admin_pictures/2', :method => :get},
        :controller => :admin_pictures.to_s, :action => :show.to_s, :id => '2')
  end

#-------------
  private

  def happy_path
    pretend_logged_in
    get :show, :id => pictures(:two).id
  end

end
