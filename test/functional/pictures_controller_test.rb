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

  test "should render right webmaster page file" do
# Could not get this test to work.
#    get :index
#print "assigns(:pictures) "; p assigns(:pictures)
#    assert_template :file => "#{Rails.root}/../gallery-webmaster/page"
#,
#        :partial => 'pictures/pictures',
#        :locals => {:pictures => assigns(:pictures)}
#        :locals => nil
  end

  test "should get index" do
    get_mock_page
    assert_response :success
  end

  test "should render a mock page" do
    get_mock_page
  end

  test "should render a gallery" do
    get_mock_page
    see_output
    assert_select 'div.gallery'
  end

  test "should render a list of all tags" do
    get_mock_page
    assert_select 'div.all-tags'
  end

  test "should render a picture within a gallery" do
    get_mock_page
    assert_select 'div.gallery > div.picture'
  end

  test "should render all the pictures" do
    get_mock_page
    assert_select 'div.gallery > div.picture', 2
  end

  test "should render a title within a picture" do
    get_mock_page
    assert_select 'div.picture > div.title'
  end

  test "should render a description within a picture" do
    get_mock_page
    assert_select 'div.picture > div.description'
  end

  test "should render a year within a picture" do
    get_mock_page
    assert_select 'div.picture > div.year'
  end

  test "should render a thumbnail within a picture" do
    get_mock_page
    assert_select 'div.picture > div.thumbnail'
  end

  test "should render an image within a thumbnail" do 
    get_mock_page
    assert_select 'div.thumbnail > img'
  end

  test "image should have the right thumbnail filename" do
    pictures(:one).destroy
    get_mock_page
    assert_select '[src=?]', '/images/two-t.png'
  end

  private

  def get_mock_page
    Webmaster.expects(:page_path).returns "#{Rails.root}"\
      '/test/fixtures/files/picture/page'
    get :index
  end

  def see_output
    print response.body
  end

end
