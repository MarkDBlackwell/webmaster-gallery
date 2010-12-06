require 'test_helper'

class EditSessionsControllerTest < SharedSessionsControllerTest

# -> Webmaster reviews filesystem changes.

  test_happy_path_response

  test "routing" do # GET
    assert_routing({:path => '/session/edit', :method => :get}, :controller =>
        :sessions.to_s, :action => :edit.to_s)
  end

  test "happy path (if logged in)..." do
    happy_path
# Should render the right template:
    assert_template :edit
# Should assign groups:
    %w[approval_group review_groups].each do |e|
      assert_present assigns(e), "Should assign @#{e}"
    end
# Review groups should include...:
    a=assigns :approval_group
    g=assigns(:review_groups).clone
    (a.blank? ? g : g << a).each do |e|
      assert_present e.list, 'list'
      assert_present e.message, 'message'
    end
  end

  test "should review added tags" do
    expected, added = construct_added_tags
    run_tags expected, added, 'add'
  end

  test "should review deleted tags" do
    expected, deleted = construct_deleted_tags
    run_tags expected, deleted, 'delet'
  end

  test "should review added pictures" do
    expected, added = construct_added_pictures
    run_pictures expected, added, 'add'
  end

  test "should review deleted pictures" do
    expected, deleted = construct_deleted_pictures
    run_pictures expected, deleted, 'delet'
  end

#-------------
  private

  def check_approval_group(changed,message)
#    assert_equal changed, assigns(:approval_group), 'Approval'
    g=assigns :approval_group
# List should be:
    assert_equal changed, g.list, 'Approval list'
# Message should be:
    assert_equal g.message, message, 'Approval message'
  end

  def check_review_groups(count,message)
    groups=assigns :review_groups
# Count should be:
    assert_equal count, groups.length, 'Review groups count'
# Messages should be:
    messages=['Tags in file:','Existing pictures:','Pictures in directory:'].
        take(count - 1).push message
    groups.each_with_index do |e,i|
      assert_equal e.message, messages.at(i), "Review group #{i}"
    end
  end

  def happy_path
    pretend_logged_in
    get :edit
  end

# Working_on

  def run_pictures(expected,changed,s)
    mock_file_tags :all
    mock_directory_pictures expected
    happy_path
    check_approval_group changed, "approve #{s}ing pictures"
    check_review_groups 4,"Pictures to be #{s}ed:"
  end

  def run_tags(expected,changed,s)
    mock_file_tags expected
    mock_directory_pictures []
    happy_path
    check_approval_group changed, "approve #{s}ing tags"
    check_review_groups 2,"Tags to be #{s}ed:"
  end

end
