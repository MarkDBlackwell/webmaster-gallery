require 'test_helper'

class LoginControllerTest < ActionController::TestCase

  test "routing /login" do
    assert_routing '/login', :controller => 'login', :action => 'index'
  end

  test "should GET index if not logged in" do
    session[:logged_in]=nil
    get :index
    assert_response :success
  end

  test "GET should redirect to /logout if already logged in" do
    session[:logged_in]=true
    get :index
    assert_redirected_to '/logout'
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

  test "GET should clear the flash" do
    flash.now[:notice]='anything'
    flash[:notice]='anything'
    get :index
    assert_nil flash[:notice]
  end

  test "POST should log in" do
    session[:logged_in]=nil
    login
    assert_equal true, session[:logged_in]
  end

  test "POST should reset the session" do
    session[:something]=true
    post :index
    assert_nil session[:something]
  end

  test "POST should copy the webmaster HTML pictures file" do
    p="#{Rails.root}/app/views/layouts/pictures.html.erb"
    File.new(p,'w').close
    login
    assert 0 < File.size(p)
  end

  test "POST should redirect to /problems" do
    login
    assert_redirected_to '/problems'
  end

  test "should have one form" do
    get :index
    assert_select 'form', 1
  end

  test "should have one form with method POST" do
    get :index
    assert_select 'form[method=post]', 1
  end

  test "should have one form with password field" do
    get :index
    assert_select 'form > input#password', 1
  end

  test "should prompt for password" do
    get :index
    assert_select 'p', :count => 1, :text => "Type the password and hit 'Enter'."
  end

  test "should flash on wrong password entered" do
    post :index, :password => 'example wrong password'
    assert_select '#error', 'Password incorrect.'
  end

  private

  def login
    f = File.new("#{Rails.root}"\
      '/test/fixtures/files/file_password/password.txt', 'r')
    clear_text_password = f.readlines.first.chomp
    f.rewind
    MyFile.expects(:my_new).returns f
    post :index, :password => clear_text_password
  end

end
