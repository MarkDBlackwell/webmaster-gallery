require 'test_helper'

class AdminPicturesControllerTest < ActionController::TestCase
  test "routing /admin_pictures" do
    assert_routing '/admin_pictures', :controller => 'admin_pictures',
      :action => 'index'
  end

  test "routing /admin_pictures/some_tag" do
    assert Date::today < Date::new(2010,10,21), 'Test unwritten.'

#    assert_routing '/admin_pictures/some_tag', :controller => "admin_pictures",
#      :action => "index", :tag => "some_tag"
  end

  test "should get index" do
    session[:logged_in]=true
    get :index
    assert_response :success
  end

  test "should redirect to /session/new if not logged in" do
    session[:logged_in]=nil
    get :index
    assert_redirected_to :controller => :sessions, :action => :new
  end
end
