require 'test_helper'

class AdminPicturesControllerTest < ActionController::TestCase

# Show action tests:

  test "routing get /admin_pictures/2" do
    assert_routing({:path => '/admin_pictures/2', :method => 'get'},
        :controller => 'admin_pictures', :action => 'show', :id => '2')
  end

  test "should get show if logged in" do
    session[:logged_in]=true
    get :show, :id => '2'
    assert_response :success
  end

end
