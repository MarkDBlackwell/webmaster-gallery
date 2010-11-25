require 'test_helper'

class UpdateAdminPicturesControllerTest < SharedAdminPicturesControllerTest

  test "routing" do
    assert_routing({:path => '/admin_pictures/2', :method => :put},
        :controller => :admin_pictures.to_s, :action => :update.to_s,
        :id => '2')
  end

  test "should redirect to /session/new if not logged in" do
    set_cookies
    put :update, :id => '2'
    assert_redirected_to :controller => :sessions, :action => :new
  end

  test_happy_path

#-------------
  private

  def happy_path
    pretend_logged_in
    put :update, :id => pictures(:two).id
  end

end
