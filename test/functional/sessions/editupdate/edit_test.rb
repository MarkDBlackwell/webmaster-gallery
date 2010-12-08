require 'test_helper'

class EditSessionsControllerTest < SharedEditUpdateSessionsControllerTest

# -> Webmaster reviews filesystem changes.

# Working_on

  test "routing" do # GET
    assert_routing({:path => '/session/edit', :method => :get}, :controller =>
        :sessions.to_s, :action => :edit.to_s)
  end

  test_happy_path_response

  test "happy path..." do
    happy_path
# Should render the right template:
    assert_template :edit
# Should assign approval and review groups:
    %w[approval_group review_groups].each do |e|
      assert_present assigns(e), "Should assign @#{e}"
    end
# Groups should include...:
    (assigns(:review_groups) << assigns(:approval_group)).
        each_with_index do |e,i|
# A list:
      assert_kind_of Array, e.list, "list #{i}"
# A message:
      assert_present e.message, "message #{i}"
      assert_kind_of String, e.message, "message #{i}"
    end
  end

  test "if nothing to approve..." do
    mock_file_tags :all
    mock_directory_pictures :all
    happy_path
# Approval group list and message should be appropriate:
    check_approval_group [], 'refresh'
  end

  test "should review unpaired directory pictures first" do
    mock_unpaired %w[a b]
    mock_file_tags []
    mock_directory_pictures []
    happy_path
    check_approval_group [], 'refresh'
    check_review_groups 2, @controller.send(:review_messages).at(1)
  end

  test "should review added tags" do
    run_tags 'add'
  end

  test "should review added pictures" do
    run_pictures 'add'
  end

  test "should review deleted tags" do
    run_tags 'delet'
  end

  test "should review deleted pictures" do
    run_pictures 'delet'
  end

#-------------
  private

  def check_approval_group(changed,message)
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
    groups.each_with_index do |e,i|
# Messages should be:
      assert_equal (@controller.send(:review_messages).take(count - 1).
          push message).at(i), e.message, "Review group #{i}"
    end
  end

  def happy_path
    pretend_logged_in
    get :edit
  end

  def run_pictures(s)
    expected, changed = case
    when 'add'  ==s then construct_added_pictures
    when 'delet'==s then construct_deleted_pictures
    end      
    mock_directory_pictures expected
    mock_unpaired []
    mock_file_tags :all
    happy_path
    check_approval_group changed, "approve #{s}ing pictures"
    check_review_groups 5,"Pictures to be #{s}ed:"
  end

  def run_tags(s)
    expected, changed = case
    when 'add'  ==s then construct_added_tags
    when 'delet'==s then construct_deleted_tags
    end      
    mock_file_tags expected
    mock_unpaired []
    mock_directory_pictures []
    happy_path
    check_approval_group changed, "approve #{s}ing tags"
    check_review_groups 3,"Tags to be #{s}ed:"
  end

end
