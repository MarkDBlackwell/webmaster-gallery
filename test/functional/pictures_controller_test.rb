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

  test "should be no route for action, uncached index" do
    procs = [
        Proc.new do |action,hash|
          get action, hash
        end,
        Proc.new do |action,hash|
          route = hash.empty? ? '' : "pictures/#{hash[:tag]}"
          assert_generates route,
              {:controller => 'pictures', :action => action}.merge(hash),
              {}, {}, 'In assert_generates proc, '\
              "route #{route}, action #{action}, hash #{hash.to_yaml}."
        end,
        ]
    [{},{:tag => 'something'}].each do |e_hash|
      procs.each do |e_proc|
        e_proc.call('index', e_hash) # A valid action should be okay.
        assert_raise(ActionController::RoutingError) do
          e_proc.call 'uncached_index', e_hash
        end
      end
    end
  end

  test "index action should cache the page" do
    fn = "#{Rails.root}"  '/public/index.html'
    File.delete(fn) if File.exist?(fn)
    get :index
    assert_equal true, 0 < File.size(fn), "#{fn} caching failed."
  end

  test "index action should cache the page for a tag" do
    fn = "#{Rails.root}"  '/public/pictures/some_tag.html'
    File.delete(fn) if File.exist?(fn)
    get :index, :tag => 'some_tag'
    assert_equal true, 0 < File.size(fn), "#{fn} caching failed."
  end

  test "should render right webmaster page file" do
# TODO: Could not get this test to work.
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
    assert_select 'div.thumbnail > * > img'
  end

  test "image should have the right thumbnail filename" do
    pictures(:one).destroy
    get_mock_page
    assert_select '[src=?]', filename_matcher('two-t.png')
  end

  test "should render the right year" do
    pictures(:one).destroy
    get_mock_page
    assert_select 'div.picture > div.year', 'two-year'
  end

  test "should render the right description" do
    pictures(:one).destroy
    get_mock_page
    assert_select 'div.picture > div.description', 'two-description'
  end

  test "should render the right title" do
    pictures(:one).destroy
    get_mock_page
    assert_select 'div.picture > div.title', 'two-title'
  end

  test "image should have the right title as alt-text" do
    pictures(:one).destroy
    get_mock_page
    assert_select '[alt=?]', 'two-title'
  end

  test "should render an anchor within a thumbnail" do 
    get_mock_page
    assert_select 'div.thumbnail > a'
  end

  test "should render an image within an anchor" do 
    get_mock_page
    assert_select 'a > img'
  end

  test "thumbnail anchor should be a link" do
    get_mock_page
    assert_select 'div.thumbnail > a[href]'
  end

  test "should render a link to the right picture" do
    pictures(:one).destroy
    get_mock_page
    assert_select '[href=?]', filename_matcher('two.png')
  end

  test "should render pretty html source" do
    get_mock_page
    divs = %w[all-tags tag gallery picture thumbnail title description year]
    s = "<div class=\"#{Regexp.union *divs}\""
# Remove any of these divs which are at line beginnings:
    altered_body = response.body.gsub( Regexp.new("\n" + s),"\n")
    s2 = altered_body.clone
# Should not be able to find any of those divs:
    assert_equal true, altered_body.gsub!(Regexp.new(s),'').nil?, s2
  end

  test "should render a tag within a list of all tags" do
    get_mock_page
    assert_select 'div.all-tags > div.tag'
  end

  test "should render the right tag name" do
    tags(:one).destroy
    get_mock_page
    assert_select 'div.all-tags > div.tag', 'two-name'
  end

  test "should not render an edit div if not editable" do
    get_mock_page
    assert_select 'div.picture > div.edit', 0
  end

  test "should render an edit div if editable" do
    mock_page
    @controller.instance_eval {@editable=true}
    get :index
    assert_select 'div.picture > div.edit'
  end

  test "should render a button within an edit div if editable" do
    mock_page
    @controller.instance_eval {@editable=true}
    get :index
    assert_select 'div.edit > form.button_to'
  end

  test "button within an edit div should have method get" do
    mock_page
    @controller.instance_eval {@editable=true}
    get :index
    assert_select 'div.edit > form.button_to[method=?]', 'get'
  end

# Copy this line into a test, if desired:
#    see_output

  private

  def get_mock_page
    mock_page
    get :index
  end

  def mock_page
    Webmaster.expects(:page_path).returns "#{Rails.root}"\
      '/test/fixtures/files/picture/page'
  end

  def see_output
    f=File.new("#{Rails.root}"\
      '/out/see-output','w')
    f.print response.body
    f.close
  end

  def filename_matcher(s)
    %r@^/images/gallery/#{s}\?\d+$@
  end

end
