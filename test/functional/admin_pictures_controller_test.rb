require 'test_helper'

class AdminPicturesControllerTest < ActionController::TestCase
  test "routing /admin_pictures" do
    assert_routing '/admin_pictures', :controller => 'admin_pictures',
      :action => 'index'
  end

# DO LATER
#  test "routing /admin_pictures/some_tag" do
#    assert_routing '/admin_pictures/some_tag', :controller => "admin_pictures",
#      :action => "index", :tag => "some_tag"
#  end

  test "should get index" do
    session[:logged_in]=true
    get :index
    assert_response :success
  end

  test "should redirect to /login if not logged in" do
    session[:logged_in]=nil
    get :index
    assert_redirected_to '/login'
  end
end
