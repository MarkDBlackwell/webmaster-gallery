require 'test_helper'

class ShowSessionsControllerTest < SharedSessionsControllerTest

# -> Webmaster reviews database problems.

#-------------
# General tests:

  test "routing" do # GET
    assert_routing({:path => '/session', :method => :get}, :controller =>
        :sessions.to_s, :action => :show.to_s)
  end

  test_happy_path_response

  test "happy path should..." do
    happy_path
# Render the right template:
    assert_template :edit
# Assign a single review group...:
    s='Review group'
    r=assigns :review_groups
    assert_present r, s
    assert_kind_of Array, r, s
    assert_equal 1, r.length, s
# Whose...:
# Message should be:
    assert_equal 'Pictures with database problems:', r.first.message, s
# List should be:
    assert_equal @problem_pictures, r.first.list, s
# Assign a single approval group...:
    s='Approval group'
    a=assigns :approval_group
    assert_present a, s
# Whose...:
# Message should be:
    assert_equal 'refresh', a.message, s
# List should be empty:
    assert_equal '', a.list, s
  end

  test "if file tags or directory pictures approval needed, should..." do
    mock_approval_needed
    get :show
# Redirect to edit:
    assert_redirected_to :action => :edit
  end

#-------------
  private

  def happy_path
    mock_approval_needed false
    Picture.expects(:find_database_problems).returns(@problem_pictures=
        %w[aa bb])
    get :show
  end

  def setup
    pretend_logged_in
  end

end
