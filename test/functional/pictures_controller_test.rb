require 'test_helper'

class PicturesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should set tag" do
    assert_recognizes( { :controller => "pictures", :action => "index", 
      :tag => "some_tag" }, '/pictures/some_tag')
  end
end
