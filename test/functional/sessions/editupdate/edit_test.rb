require 'test_helper'

class EditSessionsControllerTest < SharedEditUpdateSessionsControllerTest

# -> Webmaster reviews filesystem changes.

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
      assert_kind_of String, e.message, (s="message #{i}")
      assert_present e.message, s
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
    check_review_groups 2, (@controller.send(:review_messages).at 1)
  end

  2.times do |i|
    model = %w[tag    picture].at i
    s1    = %w[file directory].at i
    s2="mock_#{s1}_#{model}s" #->
        # mock_directory_pictures
        # mock_directory_tags
        # mock_file_pictures
        # mock_file_tags
    2.times do |k|
      operation = %w[add delet].at k
      s3="#{operation}ed_#{model}s" #->
      s4="construct_#{s3}" #->
          # construct_added_pictures
          # construct_added_tags
          # construct_deleted_pictures
          # construct_deleted_tags
      (1..2).each do |count|
        test "should review #{count} #{s3}" do
          mock_unpaired []
          0==i ? mock_directory_pictures([]) : (mock_file_tags :all)
          expected, changed = send s4, count
          send s2, expected
          happy_path
          check_approval_group changed, "approve #{operation}ing #{model}s"
          check_review_groups 3+2*i,
              "#{model.capitalize}s to be #{operation}ed:"
        end
      end
    end
  end

#-------------
  private

  def check_approval_group(changed,message)
    g=assigns :approval_group
# List should be:
    assert_equal changed.sort, g.list, 'Approval list'
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

end
