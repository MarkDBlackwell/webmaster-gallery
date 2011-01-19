require 'test_helper'

class IndexPicturesControllerTest < SharedControllerTest
# %%co%%pic%%in

  tests PicturesController

# -> Ordinary user views gallery.

  test_routing_tag root=true # GET
  test_happy_path_response

#-------------
# Caching tests:

  test "index should cache a page" do
    verify_cache 'index.html' do
      happy_path
    end
  end

  test "index should cache the page for a tag" do
    tag='some-tag'
    verify_cache ['pictures', tag+'.html'] do
      get @action, :tag => tag
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
    assert_equal 1, (@templates.fetch App.webmaster.join('page').to_s)
  end

#-------------
  private

  def happy_path
    get @action
  end

  def setup
    @controller_name=:pictures.to_s
    @action=:index
  end

  def verify_cache(a)
    args=((a.kind_of? Array) ? a.clone : [a] ).unshift 'public'
    f=App.root.join *args
    FileUtils.rm f, :force => true
    yield
    assert_equal true, 0 < f.size?, "#{f} caching failed."
  end

end
