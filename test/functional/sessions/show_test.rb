require 'test_helper'

class ShowSessionsControllerTest < SharedSessionsControllerTest

# -> Webmaster reviews database problems.
  test_happy_path_response

#-------------
# General tests:

  test "routing" do
    assert_routing({:path => '/session', :method => :get}, :controller =>
        :sessions.to_s, :action => :show.to_s)
  end

#-------------
# Already logged in tests:

# TODO: what should it show?

#-------------
  private

  def happy_path
    pretend_logged_in
    get :show
  end

end
