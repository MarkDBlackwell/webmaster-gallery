require 'test_helper'

class PicturesControllerTest < ActionController::TestCase

# Index action tests:

  test "should include this file" do
#    flunk
  end

  test "routing /" do
    assert_routing '/', :controller => :pictures.to_s, :action => :index.to_s
  end

  test "routing /pictures/some_tag" do
    assert_routing '/pictures/some_tag', :controller => :pictures.to_s,
      :action => :index.to_s, :tag => 'some_tag'
  end

  test "should raise exception on bad route /pictures" do
    assert_raise(ActionController::RoutingError) do
      assert_routing '/pictures', :controller => :pictures.to_s, :action =>
          :index.to_s
    end
  end

  test "should be no route for 'uncached_index' action" do
    procs = [
        Proc.new do |action,hash|
          get action, hash
        end,
        Proc.new do |action,hash|
          route = hash.empty? ? '' : "pictures/#{hash[:tag]}"
          assert_generates route,
              {:controller => :pictures, :action => action}.merge(hash),
              {}, {}, 'In assert_generates proc, '\
              "route #{route}, action #{action}, hash #{hash.to_yaml}."
        end,
        ]
    [{},{:tag => 'something'}].each do |e_hash|
      procs.each do |e_proc|
        e_proc.call(:index, e_hash) # A valid action should be okay.
        assert_raise(ActionController::RoutingError) do
          e_proc.call :uncached_index, e_hash
        end
      end
    end
  end

  test "should redirect to new on wrong method" do
    actions = [:index]
    try_wrong_methods(actions)
  end

  test "index should cache a page" do
    fn = "#{Rails.root}/public/index.html"
    File.delete(fn) if File.exist?(fn)
    get :index
    assert_equal true, 0 < File.size(fn), "#{fn} caching failed."
  end

  test "index should cache the page for a tag" do
    fn = "#{Rails.root}/public/pictures/some_tag.html"
    File.delete(fn) if File.exist?(fn)
    get :index, :tag => 'some_tag'
    assert_equal true, 0 < File.size(fn), "#{fn} caching failed."
  end

  test "happy path" do
    get :index
    assert_response :success
  end

  test "index should obtain a page" do
    get :index
# TODO: what is this test for?
  end

  test "index should render right webmaster page file" do
# TODO  test "index should render right webmaster page file" do
    assert Date::today < Date::new(2010,11,26), 'Test unwritten.'
# TODO: Could not get this test to work.
#    get :index
#print 'assigns(:pictures) '; p assigns(:pictures)
#    assert_template :file => "#{Gallery::Application.config.webmaster}/page"
#,
#        :partial => 'pictures/pictures',
#        :locals => {:pictures => assigns(:pictures)}
#        :locals => nil
  end

end
