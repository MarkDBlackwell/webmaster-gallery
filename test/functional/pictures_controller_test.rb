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
    assert_template :file => "#{Rails.root}/../gallery-webmaster/page",
      :layout => false
  end

=begin
  test "should render a gallery" do
    get :index
    assert_select 'div.gallery'
  end

  test "should render a picture within a gallery" do
    get :index
    assert_select 'div.gallery > div.picture'
  end

  test "should render all the pictures" do
    get :index
    assert_select 'div.gallery > div.picture', 3
  end

  test "should render a title within a picture" do
    get :index
    assert_select 'div.picture > div.title'
  end

  test "should render a description within a picture" do
    get :index
    assert_select 'div.picture > div.description'
  end

  test "should render a thumbnail within a picture" do
    get :index
    assert_select 'div.picture > div.thumbnail'
  end

  test "should render a year within a picture" do
    get :index
    assert_select 'div.picture > div.year'
  end
=end

  private

  def setup
=begin
    in
    out
put_f="#{rails.root}/test
    output_f="#{rails.root}/
    FileUtils.cp( 
=end
  end

  def teardown
  end

end
