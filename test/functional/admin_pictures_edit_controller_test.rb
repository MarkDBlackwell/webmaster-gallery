require 'test_helper'

class AdminPicturesControllerTest < ActionController::TestCase

# Edit action tests:

  test "should get edit if logged in" do
    session[:logged_in]=true
    get :edit, :id => pictures(:two).id
    assert_response :success
  end

  test "edit should render a picture" do
    session[:logged_in]=true
    get :edit, :id => pictures(:two).id
    assert_select 'div.picture'
  end

end
