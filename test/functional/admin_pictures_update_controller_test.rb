require 'test_helper'

class AdminPicturesControllerTest < ActionController::TestCase

# Update action tests:

  test "should include this update file" do
#    flunk
  end

  test "routing put /admin_pictures/2" do
    assert_routing({:path => '/admin_pictures/2', :method => 'put'},
        :controller => 'admin_pictures', :action => 'update', :id => '2')
  end

  test "should put update if logged in" do
    session[:logged_in]=true
    put :update, :id => '2'
    assert_response :success
  end

end
