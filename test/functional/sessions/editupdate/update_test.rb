require 'test_helper'

class UpdateSessionsControllerTest < SharedEditUpdateSessionsControllerTest

# <- Webmaster approves filesystem changes.

  test "routing" do # PUT
    assert_routing({:path => '/session', :method => :put}, :controller =>
        :sessions.to_s, :action => :update.to_s)
  end

#-------------
# Happy path tests:

  test_happy_path_response :edit

  test "happy path..." do
# Shouldn't read the webmaster page file:
    f=App.webmaster.join 'page.html.erb'
    remove_read_permission(f) {happy_path}
# Shouldn't make a pictures layout file:
    assert_equal false, pictures_in_layouts_directory?
  end

  test "happy path should expire cached pictures pages for one and all tags" do
    pages = %w[index pictures/two-name].collect {|e|
        App.root.join 'public', "#{e}.html" }
    FileUtils.touch pages
    happy_path
    pages.each {|e| assert_equal false, e.exist?,
        "#{e} cache expiration failed." }
  end

# Working_on

  test "shouldn't add tags if approved differ" do
    prior=tag_names
    expected, added = construct_added_tags
    added[0]='altered'
    run_tags expected, added
    assert_equal prior, tag_names
  end

  test "should add tags if approved same" do
    prior=tag_names
    expected, added = construct_added_tags
    run_tags expected, added
    assert_equal added, tag_names-prior
  end

  test "shouldn't delete tags if approved differ" do
    prior=tag_names
    expected, deleted = construct_deleted_tags
    deleted[0]='altered'
    run_tags expected, deleted
    assert_equal prior, tag_names
  end

  test "should delete tags if approved same" do
    prior=tag_names
    expected, deleted = construct_deleted_tags
    run_tags expected, deleted
    assert_equal deleted, prior-tag_names
  end

  test "shouldn't add pictures if approved differ" do
    prior=picture_filenames
    expected, added = construct_added_pictures
    added[0]='altered'
    run_pictures expected, added
    assert_equal prior, picture_filenames
  end

  test "should add pictures if approved same" do
    prior=picture_filenames
    expected, added = construct_added_pictures
    run_pictures expected, added
    assert_equal added, picture_filenames-prior
  end

  test "shouldn't delete pictures if approved differ" do
    prior=picture_filenames
    expected, deleted = construct_deleted_pictures
    deleted[0]='altered'
    run_pictures expected, deleted
    assert_equal prior, picture_filenames
  end

  test "should delete pictures if approved same" do
    prior=picture_filenames
    expected, deleted = construct_deleted_pictures
    run_pictures expected, deleted
    assert_equal deleted, prior-picture_filenames
  end

#-------------
  private

  def approve(group)
    pretend_logged_in
    put :update, :commit => 'approve changes', :approval_group =>
        group.join(' ')
  end

  def happy_path
    mock_file_tags :all
    mock_directory_pictures :all
    pretend_logged_in
    put :update, :commit => 'update-user-pictures'
  end

  def picture_filenames
    Picture.find(:all).map(&:filename).sort
  end

  def run_pictures(expected,changed)
    mock_file_tags :all
    mock_directory_pictures expected
    approve changed
  end

  def run_tags(expected,changed)
    mock_file_tags expected
    mock_directory_pictures []
    approve changed
  end

  def tag_names
    Tag.find(:all).map(&:name).sort
  end

end
