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
# Groups should include a message:
    (assigns(:review_groups) << assigns(:approval_group)).
          each_with_index do |e,i|
      assert_kind_of String, e.message, (s="message #{i}")
      assert_present e.message, s
    end
# Review groups should include a list:
    assigns(:review_groups).each_with_index do |e,i|
      assert_kind_of Array, e.list, "list #{i}"
    end
# Approval group should include a list:
    assert_kind_of String, assigns(:approval_group).list,
        'approval group list'
  end

  test "if nothing to approve..." do
    mock_file_tags
    mock_directory_pictures
    happy_path
# Approval group list and message should be appropriate:
    check_approval_group [], 'refresh'
  end

  test "should review file tag bad names first" do
    mock_file_tag_bad_names(u= %w[a b])
    mock_file_tags []
    mock_directory_pictures []
    happy_path
    check_approval_group [], 'refresh'
    check_review_groups 2, u
  end

  test "should review directory picture bad names second" do
    mock_directory_picture_bad_names(u= %w[a b])
    mock_file_tags []
    mock_directory_pictures []
    happy_path
    check_approval_group [], 'refresh'
    check_review_groups 3, u
  end

  test "should review unpaired directory pictures third" do
    mock_unpaired(u= %w[a b])
    mock_file_tags []
    mock_directory_pictures []
    happy_path
    check_approval_group [], 'refresh'
    check_review_groups 4, u
  end

  %w[tag picture].each_with_index do |model,i|
    %w[add delet].each do |operation|
      1.upto 2 do |count|
        test "should review #{count} #{operation}ed_#{model}s" do
          expected,change=construct_changes model, operation, count
          mock_expected model, expected
          happy_path
          check_approval_group change, "approve #{operation}ing #{model}s"
          check_review_groups 2*i+3, change,
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
    s='Approval'
    assert_equal (changed.sort.join ' '), g.list, "#{s} list"
# Message should be:
    assert_equal g.message, message, "#{s} message"
  end

  def check_review_groups(count,changed,m=nil)
    messages=@controller.send(:review_messages).take m ? count-1 : count
    messages.push m if m
    groups=assigns :review_groups
# Count should be:
    s1='Review group'
    assert_equal count, groups.length, "#{s1}s count"
# Review groups...
    groups.each_with_index do |e,i|
      s="#{s1} #{i}"
# Message should be:
      assert_equal messages.at(i), e.message, s
# Last group...
      next unless groups.length-1==i
# List should be:
      l=e.list
      f=l.first
      case
      when (f.kind_of? Picture) then l.map! &:filename
      when (f.kind_of? Tag    ) then l.map! &:name end
      assert_equal changed.sort, l, s
    end
  end

  def happy_path
    pretend_logged_in
    get :edit
  end

end
