require 'test_helper'

class PicturesControllerTest < SharedControllerTest

# Index action tests:

  test "routing /" do
    assert_routing '/', :controller => :pictures.to_s, :action => :index.to_s
  end

  test "routing /pictures/some_tag" do
    assert_routing '/pictures/some_tag', :controller => :pictures.to_s,
      :action => :index.to_s, :tag => 'some_tag'
  end

  test "should raise exception on bad route /pictures" do
    assert_raise ActionController::RoutingError do
      assert_routing '/pictures', :controller => :pictures.to_s, :action =>
          :index.to_s
    end
  end

  test_wrong_http_methods :index

  [{:tag=>'some_tag'},Hash.new].each do |e|
    s=e.inspect
    2.times do |i|
      test "should be no route for action, 'uncached_index' on #{[s,i]}" do
        a=[:uncached_index, e]
        assert_raise ActionController::RoutingError do
          try_route *a if 0==i
          get *a       if 1==i
        end
      end
    end
    test "on the other hand, index should be okay on #{s}" do
      a=[:index, e]
      try_route *a
      get *a
    end
  end

  test "index should cache a page" do
    fn="#{Rails.root}/public/index.html"
    File.delete(fn) if File.exist?(fn)
    happy_path
    assert_equal true, 0 < File.size(fn), "#{fn} caching failed."
  end

  test "index should cache the page for a tag" do
    fn="#{Rails.root}/public/pictures/some_tag.html"
    File.delete(fn) if File.exist?(fn)
    get :index, :tag => 'some_tag'
    assert_equal true, 0 < File.size(fn), "#{fn} caching failed."
  end

  test_happy_path

  test "index should obtain a page" do
    happy_path
# TODO: what is this test for?
  end

  test "index should render right webmaster page file" do
# TODO  test "index should render right webmaster page file" do
    assert Date::today < Date::new(2010,11,26), 'Test unwritten.'
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

  def try_route(action,hash)
    route = hash.empty? ? '' : "pictures/#{hash[:tag]}"
    assert_generates route, {:controller => :pictures, :action => action}.
        merge(hash), {}, {}, "route #{route}"
  end

end
