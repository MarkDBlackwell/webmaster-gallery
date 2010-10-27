require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  include SessionsPrivateAllControllerTest

# New action tests:
# -> Prompts webmaster to log in.

  test "routing for new" do
    assert_routing({:path => '/session/new', :method => :get},
      :controller => 'sessions', :action => 'new')
  end

  test "should new if not logged in" do
    session[:logged_in]=nil
    get :new
    assert_response :success
  end

  test "new should redirect to destroy if already logged in" do
    session[:logged_in]=true
    get :new
    assert_redirected_to :action => :destroy
  end

  test "new should clear the flash" do
    flash.now[:notice]='anything'
    flash[:notice]='anything'
    get :new
    assert_nil flash[:notice]
  end

  test "new should have one form" do
    get :new
    assert_select 'form', 1
  end

  test "new should have one form with method post" do
    get :new
    assert_select 'form[method=post]', 1
  end

  test "new should have one form with password field" do
    get :new
    assert_select 'form > input#password', 1
  end

  test "new should prompt for password" do
    get :new
    assert_select 'p', :count => 1, :text => "Type the password and hit 'Enter'."
  end

end
