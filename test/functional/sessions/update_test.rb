require 'test_helper'

class UpdateSessionsControllerTest < SharedSessionsControllerTest

# <- Webmaster approves filesystem changes.

  test "routing" do
    assert_routing({:path => '/session', :method => :put}, :controller =>
        :sessions.to_s, :action => :update.to_s)
  end

#-------------
# Happy path tests:

  test_happy_path_response

  test "happy path..." do
# Shouldn't read the webmaster page file:
    f="#{Gallery::Application.config.webmaster}/page.html.erb"
    remove_read_permission(f) {happy_path}
# Should render show:
    assert_template :show
# Shouldn't make a pictures layout file:
    assert_equal false, pictures_in_layouts_directory?
  end

  test "should add and remove pictures and tags" do
    expected = %w[one three]
    DirectoryPicture.expects(:find).returns expected.collect {|e|
        (p=DirectoryPicture.new).expects(:filename).returns e; p }
    happy_path
    assert_equal expected, Picture.find(:all).collect(&:filename).sort
    assert_equal expected, Tag.    find(:all).collect(    &:name).sort
  end

  test "should expire cached pictures pages for one and all tags" do
    pages = %w[index pictures/two-name].collect {|e|
        "#{Rails.root}/public/#{e}.html" }
    FileUtils.touch pages
    happy_path
    pages.each {|e| assert_equal false, File.exist?(e),
        "#{e} cache expiration failed." }
  end

#-------------
  private

  def happy_path
    pretend_logged_in
    put :update
  end

end
