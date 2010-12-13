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
    assert_template :show
# Should assign a single review group, whose...:
    s='Review group'
    r=assigns(:review_group)
    assert_present r, s
# List should be:
    assert_equal @problem_pictures, r.list, s
# Message should be:
    assert_equal 'Pictures with database problems:', r.message, s
  end

#-------------
# Already logged in tests:

# TODO: what should the show action do?

#-------------
  private

  def happy_path
    pretend_logged_in
    Picture.expects(:find_database_problems).returns(@problem_pictures=
        %w[aa bb])
    get :show
  end

end
