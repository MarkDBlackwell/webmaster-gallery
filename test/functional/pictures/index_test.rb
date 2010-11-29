require 'test_helper'

class IndexPicturesControllerTest < SharedControllerTest
  tests PicturesController

# -> Ordinary user views gallery.
  test_happy_path_response

#-------------
# Routing tests:

  test "routing..." do
    assert_routing '/', :controller => :pictures.to_s, :action => :index.to_s
    assert_routing '/pictures/some_tag', :controller => :pictures.to_s,
      :action => :index.to_s, :tag => 'some_tag'
# Should raise exception on bad route /pictures:
    assert_raise ActionController::RoutingError do
      assert_routing '/pictures', :controller => :pictures.to_s, :action =>
          :index.to_s
    end
  end

#-------------
# Caching tests:

  test "index should cache a page" do
    fn="#{Rails.root}/public/index.html"
    FileUtils.rm fn, :force => true
    happy_path
    assert_equal true, 0 < File.size(fn), "#{fn} caching failed."
  end

  test "index should cache the page for a tag" do
    fn="#{Rails.root}/public/pictures/some_tag.html"
    FileUtils.rm fn, :force => true
    get :index, :tag => 'some_tag'
    assert_equal true, 0 < File.size(fn), "#{fn} caching failed."
  end

#-------------
# Webmaster page file tests:

  test "index should obtain a page" do
    happy_path
# TODO: what is this test for?
  end

  test "index should render right webmaster page file" do
# TODO  test "index should render right webmaster page file" do
    assert Date::today < Date::new(2010,12,10), 'Test unwritten.'
# TODO: Could not get this test to work.
#    happy_path
#print 'assigns(:pictures) '; p assigns(:pictures)
#    assert_template :file => "#{Gallery::Application.config.webmaster}/page",
#        :partial => 'pictures/pictures',
#        :locals => {:pictures => assigns(:pictures)}
#        :locals => nil
  end

#-------------
  private

  def happy_path
    get :index
  end

end
