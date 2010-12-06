require 'test_helper'

class EditSessionsControllerTest < SharedSessionsControllerTest

# -> Webmaster reviews filesystem changes.

  test_happy_path_response

  test "routing" do
    assert_routing({:path => '/session/edit', :method => :get}, :controller =>
        :sessions.to_s, :action => :edit.to_s)
  end

  test "happy path (if logged in)..." do
    happy_path
# Should render edit:
    assert_template :edit
# Should assign groups:
    %w[approval_group review_groups].each do |e|
      assert_present assigns(e), "Should assign @#{e}"
    end
# Review groups should include...:
    assigns(:review_groups).each do |e|
      assert_present e.list, 'list'
      assert_present e.message, 'message'
    end
  end

  test "should review added tags" do
    expected, added = construct_added_tags
    run_tags expected, added, 'added'
  end

  test "should review deleted tags" do
    expected, deleted = construct_deleted_tags
    run_tags expected, deleted, 'deleted'
  end

  test "should review added pictures" do
    expected, added = construct_added_pictures
    run_pictures expected, added, 'added'
  end

  test "should review deleted pictures" do
    expected, deleted = construct_deleted_pictures
    run_pictures expected, deleted, 'deleted'
  end

#-------------
  private

  def check_approval_group(value)
    assert_equal value, assigns(:approval_group), 'Approval'
  end

  def check_review_groups(count,message)
    r=assigns :review_groups
    # Count should be:
    assert_equal count, r.length, 'Review group length'
    # Messages should be:
    messages=['Tags in file:','Existing pictures:','Pictures in directory:'].
        take(count - 1).push message
    r.each_with_index do |e,i|
      assert_equal e.message, messages.at(i), "#{message} #{i}"
    end
  end

  def happy_path
    pretend_logged_in
    get :edit
  end

# Working_on

  def run_pictures(expected,change,s)
    mock_file_tags :all
    mock_directory_pictures expected
    happy_path
    check_approval_group change
    check_review_groups 4,"Pictures to be #{s}:"
  end

  def run_tags(expected,change,s)
    mock_file_tags expected
    mock_directory_pictures []
    happy_path
    check_approval_group change
    check_review_groups 2,"Tags to be #{s}:"
  end

end
