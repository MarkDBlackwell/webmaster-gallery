require 'test_helper'

class PicturesControllerTest < ActionController::TestCase
  test "routing /" do
    assert_routing '/', :controller => 'pictures', :action => 'index'
  end

  test "routing /pictures/some_tag" do
    assert_routing '/pictures/some_tag', :controller => "pictures",
      :action => "index", :tag => "some_tag"
  end

  test "should raise exception on bad route /pictures" do
    begin
      assert_routing '/pictures', :controller => "pictures", :action => "index"
      flunk "should have failed"
    rescue ActionController::RoutingError # Expected.
    end
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should render this template" do
    get :index
    assert_template 'layouts/pictures'
  end

end
