require 'test_helper'

class UpdateSessionsControllerTest < SharedSessionsControllerTest

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
    remove_read_permission(f){happy_path}
# Shouldn't make a pictures layout file:
    assert_equal false, pictures_in_layouts_directory?
  end

  test "happy path should expire cached pictures pages for one and all tags" do
    pages = %w[index  pictures/two-name].map{|e|
        App.root.join 'public', "#{e}.html" }
    FileUtils.touch pages
    Picture.expects(:find_database_problems).returns []
    happy_path
    pages.each{|e| assert_equal false, e.exist?,
        "#{e} cache expiration failed." }
  end

  test "refresh from show" do
    mock_file_tags
    mock_directory_pictures
    pretend_logged_in
    put :update, :commit => 'refresh database problems'
# Should redirect to the same place:
    assert_redirected_to :action => :show
  end

  test "if file problems..." do
    mock_approval_needed
# Should not expire cached pages:
    @controller.expects(:delete_cache).never
    happy_path
  end

  test "if database problems..." do
    mock_approval_needed false
    Picture.expects(:find_database_problems).returns %w[aa bb]
# Should not expire cached pages:
    @controller.expects(:delete_cache).never
    happy_path
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
        end

        test "shouldn't #{operation} #{count} #{model}s if approved differ" do
          before=model_names model
          expected,change=construct_changes_strings model, operation, count
          change[0]='altered'
          assert_equal before.sort, (run_models model, expected, change).sort
        end
      end
    end
  end

#-------------
  private

  def happy_path
    mock_file_tags
    mock_directory_pictures
    mock_unpaired_names []
    pretend_logged_in
    update_user_pictures
  end

  def run_models(model,expected,changed)
    mock_expected model, expected
    pretend_logged_in
    put :update, :commit => 'approve changes', :approval_group =>
        (changed.sort.reverse.join ' ')
    model_names model
  end

  def setup
    dp=DirectoryPicture
    [:find,:find_bad_names,:find_unpaired_names].each{|e|
        dp.expects(e).at_least(0).returns [] }
  end

  def update_user_pictures
    put :update, :commit => 'update-user-pictures'
  end

end
