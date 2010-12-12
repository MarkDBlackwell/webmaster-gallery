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
    remove_read_permission(f){happy_path}
# Shouldn't make a pictures layout file:
    assert_equal false, pictures_in_layouts_directory?
  end

  test "happy path should expire cached pictures pages for one and all tags" do
    pages = %w[index  pictures/two-name].map{|e|
        App.root.join 'public', "#{e}.html" }
    FileUtils.touch pages
    happy_path
    pages.each{|e| assert_equal false, e.exist?,
        "#{e} cache expiration failed." }
  end

  2.times do |i|
    model = %w[tag    picture].at i
    s     = %w[file directory].at i
    name  = %w[name  filename].at i
    s1="#{model}_#{name}s" #->
        # picture_filenames
        # tag_names
    2.times do |k|
      operation = %w[add delet].at k
      s3="construct_#{operation}ed_#{model}s" #->
          # construct_added_pictures
          # construct_added_tags
          # construct_deleted_pictures
          # construct_deleted_tags
      (1..2).each do |count|
        test "should #{operation} #{count} #{model}s if approved same" do
          before=send s1
          expected,changed=send s3, model, operation, count
          run_models model, expected, changed
          after=send s1
          difference=case k
          when 0 then after - before
          when 1 then before - after end
          assert_equal changed.sort, difference.sort
        end

        test "shouldn't #{operation} #{count} #{model}s if approved differ" do
          before=send s1
          expected,changed=send s3, model, operation, count
          changed[0]='altered'
          run_models model, expected, changed
          assert_equal before.sort, (send s1).sort
        end
      end
    end
  end

#-------------
  private

  def happy_path
    mock_file_tags :all
    mock_directory_pictures :all
    pretend_logged_in
    put :update, :commit => 'update-user-pictures'
  end

  def run_models(model,expected,changed)
    case model
    when 'picture'
      mock_directory_pictures expected
      mock_file_tags :all
    when 'tag'
      mock_directory_pictures []
      mock_file_tags expected
    end
    mock_unpaired []
    pretend_logged_in
    put :update, :commit => 'approve changes', :approval_group =>
        (changed.sort.reverse.join ' ')
  end

end
