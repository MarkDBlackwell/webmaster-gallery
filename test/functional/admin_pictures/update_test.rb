require 'test_helper'
should_include_this_file

class AdminPicturesUpdateControllerTest < ActionController::TestCase
  tests AdminPicturesController

  test "routing" do
    assert_routing({:path => '/admin_pictures/2', :method => :put},
        :controller => :admin_pictures.to_s, :action => :update.to_s,
        :id => '2')
  end

  test "should redirect to /session/new if not logged in" do
    set_cookies
    put :update, :id => '2'
    assert_redirected_to :controller => :sessions, :action => :new
  end

  test "happy path" do
    pretend_logged_in
    put :update, :id => pictures(:two).id
    assert_response :success
  end

end