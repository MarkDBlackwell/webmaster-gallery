require 'test_helper'

class UpdateSessionsControllerTest < SharedSessionsControllerTest

# <- Webmaster approves filesystem changes.

#-------------
# General tests:

  test "routing" do
    assert_routing({:path => '/session', :method => :put}, :controller =>
        :sessions.to_s, :action => :update.to_s)
  end

  test_happy_path

  test "should redirect to new if not logged in" do
    set_cookies
    put :update
    assert_redirected_to :action => :new
  end

#-------------
# Already logged in tests:

  test "should render show" do
    happy_path
    assert_template :show
  end

  test "should add and remove tags" do
    happy_path
    assert_equal %w[one three], Tag.find(:all).collect(&:name).sort
  end

  test "should add and remove pictures" do
    a=DirectoryPicture.new
    b=DirectoryPicture.new
    a.expects(:filename).returns 'one'
    b.expects(:filename).returns 'three'
    DirectoryPicture.expects(:find).returns [a,b]
    happy_path
    assert_equal %w[one three], Picture.find(:all).collect(&:filename).sort
  end

  test "should expire a cached pictures index page" do
    fn = "#{Rails.root}/public/index.html"
    File.open(fn,'w').close
    happy_path
    assert_equal false, File.exist?(fn), "#{fn} cache expiration failed."
  end

  test "should expire a cached pictures index page for a tag" do
    fn = "#{Rails.root}/public/pictures/two-name.html"
    File.open(fn,'w').close
    happy_path
    assert_equal false, File.exist?(fn), "#{fn} cache expiration failed."
  end

  test "shouldn't make a pictures layout file" do
    happy_path
    assert_equal false, pictures_in_layouts_directory?
  end

  test "shouldn't read the webmaster page file" do
    fn="#{Gallery::Application.config.webmaster}/page.html.erb"
    remove_read_permission(fn) {happy_path}
  end

#-------------
  private

  def happy_path
    pretend_logged_in
    put :update
  end

end
