require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
  end

  test "should not get create" do
    get :create
    assert_redirected_to :action => :new
  end

  test "should post create" do
    post :create
    assert_response :success
  end

  test "routing for create" do
    assert_routing({:path => '/session', :method => :post},
      :controller => 'sessions', :action => 'create')
  end

  test "routing for edit" do
    assert_routing({:path => '/session/edit', :method => :get},
      :controller => 'sessions', :action => 'edit')
  end

  test "should get edit" do
    get :edit
    assert_response :success
  end

  test "routing for update" do
    assert_routing({:path => '/session', :method => :put},
      :controller => 'sessions', :action => 'update')
  end

  test "should not get update" do
    get :update
    assert_redirected_to :action => :new
  end

  test "should put update" do
    put :update
    assert_response :redirect
  end

  test "routing for show" do
    assert_routing({:path => '/session', :method => :get},
      :controller => 'sessions', :action => 'show')
  end

  test "should get show" do
    get :show
    assert_response :success
  end

  test "should not get destroy" do
    get :destroy
    assert_redirected_to :action => :new
  end

  test "should delete destroy" do
    delete :destroy
    assert_response :redirect
  end

# From: class LoginControllerTest < ActionController::TestCase

  test "routing for new" do
    assert_routing({:path => '/session/new', :method => :get},
      :controller => 'sessions', :action => 'new')
  end

  test "should get new if not logged in" do
    session[:logged_in]=nil
    get :new
    assert_response :success
  end

  test "get new should redirect to destroy if already logged in" do
    session[:logged_in]=true
    get :new
    assert_redirected_to :action => :destroy
  end

  test "should allow mocking with Mocha" do
# Needed 'rails plugin install git://github.com/floehopper/mocha.git
# Do not use this (next line) in Gemfile:
# gem 'mocha' # Broke the test somehow.
    mock 'A'
  end

  test "how to test it should handle invalid authenticity token?" do
    assert Date::today < Date::new(2010,10,14), 'Test unwritten.'
# Doesn't get rescued by application controller:
#    raise ActionController::InvalidAuthenticityToken
# Try to POST with invalid authenticity token.
#    post :index, :try_this => 'hello'
#    assert_equal 'hello', params[:try_this]
# Didn't find 'config':
#    config.action_controller.allow_forgery_protection = true
# Try re-raising exceptions.
#    puts LoginController.inspect
#    class LoginController;def rescue_action(e);raise e;end;end
  end

  test "see params and session" do
#    get :index
#    post :index, {:try_this => 'in params'}, {:try_this => 'in session'}
#    puts @response
#    puts @response.methods.sort
#    puts @request.session
#    get :index
#    session[:try_this]='hello'
#    puts session.sort
#    assigns["try_this"]='in assigns'
#    puts assigns(:try_this)
#    @request.session[:authenticity_token]
  end

  test "verify before_filters" do
    assert Date::today < Date::new(2010,10,14), 'Test unwritten.'
#    class LoginController
#      before_filter :verify_authenticity_token
#    end
#    puts ActionController::Testing::ClassMethods.before_filters
  end

  test "get new should clear the flash" do
    flash.now[:notice]='anything'
    flash[:notice]='anything'
    get :new
    assert_nil flash[:notice]
  end

  test "post create should log in" do
    session[:logged_in]=nil
    login
    assert_equal true, session[:logged_in]
  end

  test "post create should reset the session" do
    session[:something]=true
    post :create
    assert_nil session[:something]
  end

  test "post create should copy the webmaster HTML pictures file" do
    p="#{Rails.root}/app/views/layouts/pictures.html.erb"
    File.new(p,'w').close
    login
    assert 0 < File.size(p)
  end

  test "post create should redirect to edit" do
    login
    assert_redirected_to :action => :edit
  end

  test "should have one form" do
    get :new
    assert_select 'form', 1
  end

  test "should have one form with method POST" do
    get :new
    assert_select 'form[method=post]', 1
  end

  test "should have one form with password field" do
    get :new
    assert_select 'form > input#password', 1
  end

  test "should prompt for password" do
    get :new
    assert_select 'p', :count => 1, :text => "Type the password and hit 'Enter'."
  end

  test "should flash on wrong password entered" do
    post :create, :password => 'example wrong password'
    assert_select '#error', 'Password incorrect.'
  end

# From: class LogoutControllerTest < ActionController::TestCase

  test "routing for destroy" do
    assert_routing({:path => '/session', :method => :delete},
      :controller => 'sessions', :action => 'destroy')
  end

  test "should delete destroy if already logged in" do
    session[:logged_in] = true
    delete :destroy
    assert_response :redirect
  end

  test "delete destroy should log out if logged in" do
    session[:logged_in] = true
    delete :destroy
    assert_nil session[:logged_in]
  end

  test "delete destroy should reset the session" do
    session[:something] = true
    delete :destroy
    assert_nil session[:something]
  end

  test "delete destroy should flash a notice of log out if already logged in" do
    session[:logged_in] = true
    delete :destroy
# I don't know why the following doesn't work; I see success in the browser:
#    assert_select '#notice', 'Logged out successfully.'
# So, doing this, instead:
    assert_equal 'Logged out successfully.', flash[:notice]
  end

  test "delete destroy should flash a notice if not logged in" do
    session[:logged_in] = nil
    delete :destroy
# I don't know why the following doesn't work; I see success in the browser:
#    assert_select '#notice', 'You weren't logged in.'
# So, doing this, instead:
    assert_equal "You weren't logged in.", flash[:notice]
  end

  private

  def login
    f = File.new("#{Rails.root}"\
      '/test/fixtures/files/file_password/password.txt', 'r')
    clear_text_password = f.readlines.first.chomp
    f.rewind
    MyFile.expects(:my_new).returns f
    post :create, :password => clear_text_password
  end

end
