require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  include SessionsPrivateAllControllerTest

# Create action tests:
# <- Webmaster logs in.

  test "routing for create" do
    assert_routing({:path => '/session', :method => :post},
      :controller => 'sessions', :action => 'create')
  end

  test "should create" do
    post :create
    assert_response :redirect
  end

  test "create should redirect to edit" do
    login
    assert_redirected_to :action => :edit
  end

  test "if no difference, create should render show" do
    assert Date::today < Date::new(2010,10,29), 'Test unwritten.'
  end

  test "create should log in" do
    session[:logged_in]=nil
    login
    assert_equal true, session[:logged_in]
  end

  test "create should flash on wrong password entered" do
    post :create, :password => 'example wrong password'
    assert_equal 'Password incorrect.', flash[:error]
  end

  test "create should reset the session" do
    session[:something]=true
    post :create
    assert_nil session[:something]
  end

  test "how to test it should handle invalid authenticity token?" do
    assert Date::today < Date::new(2010,10,29), 'Test unwritten.'
# Doesn't get rescued by application controller:
#    raise ActionController::InvalidAuthenticityToken
# Try to POST with invalid authenticity token.
#    post :create, :try_this => 'hello'
#    assert_equal 'hello', params[:try_this]
# Didn't find 'config':
#    config.action_controller.allow_forgery_protection = true
# Try re-raising exceptions.
#    puts LoginController.inspect
#    class LoginController;def rescue_action(e);raise e;end;end
# See params and session.
#    post :create, {:try_this => 'in params'}, {:try_this => 'in session'}
#    puts @response
#    puts @response.methods.sort
#    puts @request.session
#    post :create
#    session[:try_this]='hello'
#    puts session.sort
#    assigns["try_this"]='in assigns'
#    puts assigns(:try_this)
#    @request.session[:authenticity_token]
  end

  test "create shouldn't make a pictures layout file" do
    login
    assert_equal false, pictures_in_layouts_directory?
  end

  test "create shouldn't read the webmaster page file" do
    path="#{Rails.root}/../gallery-webmaster/page.html.erb"
    remove_read_permission(path) {login}
  end

end
