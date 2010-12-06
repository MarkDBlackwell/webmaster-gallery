require 'test_helper'

class IndexPicturesControllerTest < SharedControllerTest
  tests PicturesController

# -> Ordinary user views gallery.

  test_happy_path_response

#-------------
# Routing tests:

  test "routing..." do # GET
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
    verify_cache 'index.html' do
      happy_path
    end
  end

  test "index should cache the page for a tag" do
    verify_cache %w[pictures some_tag.html] do
      get :index, :tag => 'some_tag'
    end
  end

#-------------
# Webmaster page file tests:

  test "index should obtain a page" do
    happy_path
# TODO: what is this test for?
  end

  test "index should render right webmaster page file" do
    happy_path
    assert_equal 1, @templates.fetch(App.webmaster.join('page').to_s)
  end

#-------------
  private

  def happy_path
    get :index
  end

  def verify_cache(a)
    args=(a.kind_of?(Array) ? a.clone : [a] ).unshift 'public'
    f=App.root.join *args
    FileUtils.rm f, :force => true
    yield
    assert_equal true, 0 < f.size?, "#{f} caching failed."
  end

end
