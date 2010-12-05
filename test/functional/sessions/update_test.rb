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
    f=App.webmaster.join 'page.html.erb'
    remove_read_permission(f) {happy_path}
# Shouldn't make a pictures layout file:
    assert_equal false, pictures_in_layouts_directory?
# Should render show:
    assert_template :show
  end

  test "happy path should expire cached pictures pages for one and all tags" do
    pages = %w[index pictures/two-name].collect {|e|
        App.root.join 'public', "#{e}.html" }
    FileUtils.touch pages
    happy_path
    pages.each {|e| assert_equal false, e.exist?,
        "#{e} cache expiration failed." }
  end

  test "happy path should add and remove pictures and tags" do
    expected = %w[one three]
    DirectoryPicture.expects(:find).returns expected.collect {|e|
        (p=DirectoryPicture.new).expects(:filename).returns e; p }
    happy_path
    assert_equal expected, Picture.find(:all).collect(&:filename).sort
    assert_equal expected, Tag.    find(:all).collect(    &:name).sort
  end

# Working_on

  test "should add tags if file contents same" do
#    expected=tag_names
    expected=FileTag.find(:all).map(&:name)
    pretend_logged_in
    put :update # TODO: add parameters.
    assert_equal expected, tag_names
  end

  test "shouldn't add tags if file contents differ" do
    expected=tag_names
    mock_file_tags expected
    happy_path
    assert_equal expected, tag_names
  end

#-------------
  private

  def happy_path
    pretend_logged_in
    put :update
  end

  def picture_filenames
    Picture.find(:all).map(&:filename).sort
  end

  def tag_names
    Tag.find(:all).map(&:name).sort
  end

end
