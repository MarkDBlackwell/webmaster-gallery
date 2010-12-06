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
  end

#-------------
# Already logged in tests:

# TODO: what should the show action do?

#-------------
  private

  def happy_path
    pretend_logged_in
    get :show
  end

end
