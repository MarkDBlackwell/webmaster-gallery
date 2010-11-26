require 'test_helper'

class ShowSessionsControllerTest < SharedSessionsControllerTest

# -> Webmaster reviews database problems.

#-------------
# General tests:

  test "routing" do
    assert_routing({:path => '/session', :method => :get}, :controller =>
        :sessions.to_s, :action => :show.to_s)
  end

  test_happy_path_response

  test_if_not_logged_in_redirect_from :show

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
