require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  include SessionsPrivateAllControllerTest

# Edit action tests:
# -> Webmaster reviews filesystem changes.

  test "routing for edit" do
    assert_routing({:path => '/session/edit', :method => :get},
      :controller => 'sessions', :action => 'edit')
  end

  test "should edit" do
    get :edit
    assert_response :success
  end

end
