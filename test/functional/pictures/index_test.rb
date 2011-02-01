require 'test_helper'

class IndexPicturesControllerTest < SharedControllerTest
# %%co%%pic%%in

  tests PicturesController # Define @controller.

# -> Ordinary user views gallery.

  test_routing_tag directory_root=true # GET
  test_happy_path_response

  test "happy path should..." do
    happy_path
# Assign pictures:
    assert_present assigns :pictures
# Assign the right pictures:
    assert_equal PictureSet.get, (assigns :pictures)
# Render the right webmaster page file:
    assert_equal 1, (@templates.fetch App.webmaster.join('page').to_s)
  end

#-------------
# Caching tests:

  test "index should cache a page" do
    verify_cache('index.html'){happy_path}
  end

  test "index should cache the page for a tag" do
    verify_cache ['pictures', "#{s='some-tag'}.html"] do
      get @action, :tag => s
    end
  end

#-------------
  private

  def happy_path
    get @action
  end

  def setup
    @controller_name=:pictures
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
