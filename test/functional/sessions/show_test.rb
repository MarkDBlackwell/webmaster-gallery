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

  test "happy path..." do
    happy_path
# Should render the right template:
    assert_template :edit
# Should assign a single review group, whose...:
    s='Review group'
    r=assigns :review_groups
    assert_present r, s
    assert_kind_of Array, r, s
    assert_equal 1, r.length, s
# List should be:
    assert_equal @problem_pictures, r.first.list, s
# Message should be:
    assert_equal 'Pictures with database problems:', r.first.message, s
# Should assign a single approval group, whose...:
    s='Approval group'
    a=assigns :approval_group
    assert_present a, s
# List should be empty:
    assert_equal '', a.list, s
# Message should be:
    assert_equal 'refresh', a.message, s
  end

#-------------
  private

  def happy_path
    pretend_logged_in
    Picture.expects(:find_database_problems).returns(@problem_pictures=
        %w[aa bb])
    get :show
  end

end
