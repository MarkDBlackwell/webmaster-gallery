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

  %w[tag picture].each_with_index do |model,i|
    names="#{model}_#{'file' if 1==i}names" #->
        # picture_filenames
        # tag_names
    %w[add delet].each do |operation|
      1.upto 2 do |count|
        test "should #{operation} #{count} #{model}s if approved same" do
          before=send names
          expected,changed=construct_changes model, operation, count
          run_models model, expected, changed
          after=send names
          difference=case operation
          when 'add'   then after - before
          when 'delet' then before - after end
          assert_equal changed.sort, difference.sort
        end

        test "shouldn't #{operation} #{count} #{model}s if approved differ" do
          before=send names
          expected,changed=construct_changes model, operation, count
          changed[0]='altered'
          run_models model, expected, changed
          assert_equal before.sort, (send names).sort
        end
      end
    end
  end

#-------------
  private

  def happy_path
    mock_file_tags
    mock_directory_pictures
    pretend_logged_in
    put :update, :commit => 'update-user-pictures'
  end

  def run_models(model,expected,changed)
    mock_expected model, expected
    pretend_logged_in
    put :update, :commit => 'approve changes', :approval_group =>
        (changed.sort.reverse.join ' ')
  end

end
