require 'test_helper'

class UpdateSessionsControllerTest < SharedSessionsControllerTest
# %%co%%ses%%up

# <- Webmaster approves filesystem changes.

  test "routing" do # PUT
    assert_routing({:path => '/session', :method => :put}, :controller =>
        :sessions.to_s, :action => :update.to_s)
  end

  test_happy_path_response :show

  test "happy path should..." do
    pages = [nil, '/pictures/two-name'].map{|e| App.root.join 'public',
        "#{path_prefix}#{e}.html" }
    FileUtils.touch pages
    Picture.expects(:find_database_problems).returns []
# Rebuild the pictures pages cache:
    @controller.expects :cache_user_picture_pages
# Not read the webmaster page file:
    remove_read_permission(App.webmaster.join 'page.html.erb'){happy_path}
# Expire cached pictures pages for one and all tags:
    pages.each{|e| assert_equal false, e.exist?,
        "#{e} cache expiration failed." }
# Not make a pictures layout file:
    assert_equal false, pictures_in_layouts_directory?
# Flash:
    assert_equal 'Updating user pictures.', flash[:notice]
  end

  test "when refreshing in show, should..." do
    mock_file_tags
    mock_directory_pictures
    pretend_logged_in
    put :update, :commit => 'refresh database problems'
# Redirect to show, again:
    assert_redirected_to :action => :show
  end

  test "if file problems, should..." do
    mock_approval_needed
# Not expire cached pages:
    @controller.expects(:delete_cache).never
    happy_path
# Redirect to edit:
    assert_redirected_to :action => :edit
  end

  test "if database problems, should..." do
    mock_approval_needed false
    Picture.expects(:find_database_problems).returns %w[aa bb]
# Not expire cached pages:
    @controller.expects(:delete_cache).never
    happy_path
# Redirect to edit:
    assert_redirected_to :action => :edit
  end

  %w[tag picture].each do |model|
    %w[add delet].each do |operation|
      1.upto 2 do |count|
        test "should #{operation} #{count} #{model}s if approved same" do
          before=model_names model
          expected,change=construct_changes_strings model, operation, count
          after=run_models model, expected, change
          assert_equal change.sort, case operation
              when 'add'   then after - before
              when 'delet' then before - after
              end.sort
# Redirect to edit:
          assert_redirected_to :action => :edit
        end

        test "shouldn't #{operation} #{count} #{model}s if approved differ" do
          before=model_names model
          expected,change=construct_changes_strings model, operation, count
          change[0]='altered'
          assert_equal before.sort, (run_models model, expected, change).sort
# Redirect to edit:
          assert_redirected_to :action => :edit
        end
      end
    end
  end

#-------------

  def setup
    dp=DirectoryPicture
    [:all,:find_bad_names,:find_unpaired_names].each{|e|
        dp.expects(e).at_least(0).returns [] }
  end

  private

  def happy_path
# TODO: here, use mock_files_invalid & mock_approval_needed.
    mock_file_tags
    mock_directory_pictures
    mock_unpaired_names []
    pretend_logged_in
    update_user_pictures
  end

  def path_prefix
    'webmas-gallery'
  end

  def run_models(model,expected,changed)
    mock_expected model, expected
    pretend_logged_in
    put :update, :commit => 'approve changes', :approval_group =>
        (changed.sort.reverse.join ' ')
    model_names model
  end

  def update_user_pictures
    put :update, :commit => 'update-user-pictures'
  end

end
