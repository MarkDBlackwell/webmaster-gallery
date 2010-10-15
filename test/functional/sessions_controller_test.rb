require 'test_helper'

class SessionsControllerTest < ActionController::TestCase

#-------------
# All actions tests:

  test "should allow mocking with Mocha" do
# Needed 'rails plugin install git://github.com/floehopper/mocha.git
# Do not use this (next line) in Gemfile:
# gem 'mocha' # Broke the test somehow.
    mock 'A'
  end

  test "verify before_filters" do
    assert Date::today < Date::new(2010,10,21), 'Test unwritten.'
#    class SessionsController
#      before_filter :verify_authenticity_token
#    end
#    puts ActionController::Testing::ClassMethods.before_filters
  end

  test "should redirect to new on wrong method" do
# Reference: 'ActionController - PROPFIND and other HTTP request methods':
# at http://railsforum.com/viewtopic.php?id=30137

    Restful = Struct.new(:action, :method)
    [   Restful.new(:create,  'post'),
        Restful.new(:destroy, 'delete'),
        Restful.new(:edit,    'get'),
        Restful.new(:new,     'get'),
        Restful.new(:show,    'get'),
        Restful.new(:update,  'put')].each do |rest|
      (ActionController::Request::HTTP_METHODS-[rest[:method]]).each do |method|
        process rest[:action], nil, nil, nil, method
        assert_redirected_to({:action => :new}, "Action #{rest[:action]},"\
          "method #{method}.")
      end
    end
  end

#-------------
# New action tests:
# -> Prompts webmaster to log in.

  test "routing for new" do
    assert_routing({:path => '/session/new', :method => :get},
      :controller => 'sessions', :action => 'new')
  end

  test "should new" do
    get :new
    assert_response :success
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

#-------------
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

  test "create should log in" do
    session[:logged_in]=nil
    login
    assert_equal true, session[:logged_in]
  end

  test "create should reset the session" do
    session[:something]=true
    post :create
    assert_nil session[:something]
  end

  test "create should not write the webmaster HTML pictures file" do
    p="#{Rails.root}/app/views/layouts/pictures.html.erb"
    mode=File.stat(p).mode
    File.chmod(mode - 0200, p)
    begin
      login
    rescue Errno::EACCES
      flunk
    ensure
      File.chmod(mode, p)
    end
  end

  test "create should redirect to edit" do
    login
    assert_redirected_to :action => :edit
  end

  test "create should flash on wrong password entered" do
    post :create, :password => 'example wrong password'
    assert_equal 'Password incorrect.', flash[:error]
  end

  test "how to test it should handle invalid authenticity token?" do
    assert Date::today < Date::new(2010,10,21), 'Test unwritten.'
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

  test "if no difference, create should render show" do
    assert Date::today < Date::new(2010,10,21), 'Test unwritten.'
  end

#-------------
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

#-------------
# Update action tests:
# <- Webmaster approves filesystem changes.

  test "routing for update" do
    assert_routing({:path => '/session', :method => :put},
      :controller => 'sessions', :action => 'update')
  end

  test "should update" do
    put :update
    assert_response :success
  end

  test "update should render show" do
    put :update
    assert_template 'show'
  end

  test "update should add and remove tags" do
    put :update
    assert_equal ['one','three'], Tag.find(:all).collect(&:name).sort
  end

  test "update should add and remove pictures" do
    a=DirectoryPicture.new
    b=DirectoryPicture.new
    a.expects(:filename).returns 'one'
    b.expects(:filename).returns 'three'
    DirectoryPicture.expects(:find).returns [a,b]
    put :update
    assert_equal ['one','three'], Picture.find(:all).collect(&:filename).sort
  end

  test "update should copy the webmaster HTML pictures file" do
    p="#{Rails.root}/app/views/layouts/pictures.html.erb"
    File.new(p,'w').close
    put :update
    assert 0 < File.size(p)
  end

#  test "update should strip ERb tags from the webmaster HTML pictures file" do
# Decided not to do this.
#  end

#-------------
# Show action tests:
# -> Webmaster reviews database problems.

  test "routing for show" do
    assert_routing({:path => '/session', :method => :get},
      :controller => 'sessions', :action => 'show')
  end

  test "should show" do
    get :show
    assert_response :success
  end

#-------------
# Destroy action tests:
# <- Webmaster logs out.

  test "routing for destroy" do
    assert_routing({:path => '/session', :method => :delete},
      :controller => 'sessions', :action => 'destroy')
  end

  test "should destroy" do
    delete :destroy
    assert_response :redirect
  end

  test "should destroy if already logged in" do
    session[:logged_in] = true
    delete :destroy
    assert_response :redirect
  end

  test "destroy should log out if logged in" do
    session[:logged_in] = true
    delete :destroy
    assert_nil session[:logged_in]
  end

  test "destroy should reset the session" do
    session[:something] = true
    delete :destroy
    assert_nil session[:something]
  end

  test "try to remove the session cookie" do
    assert Date::today < Date::new(2010,10,15), 'Test unwritten.'
# Reference config/initializes/session_store.rb for cookie name.
  end

  test "destroy should flash a notice if not logged in" do
    session[:logged_in] = nil
    delete :destroy
# I don't know why the following doesn't work; I see success in the browser:
#    assert_select '#notice', 'You weren't logged in.'
# So, doing this, instead:
    assert_equal "You weren't logged in.", flash[:notice]
  end

  test "destroy should flash a notice of log out if already logged in" do
    session[:logged_in] = true
    delete :destroy
# I don't know why the following doesn't work; I see success in the browser:
#    assert_select '#notice', 'Logged out successfully.'
# So, doing this, instead:
    assert_equal 'Logged out successfully.', flash[:notice]
  end

#-------------
  private

  def login
    f = File.new("#{Rails.root}"\
      '/test/fixtures/files/file_password/password.txt', 'r')
    clear_text_password = f.readline("\n").chomp "\n"
    f.rewind
    MyFile.expects(:my_new).returns f
    post :create, :password => clear_text_password
  end

end
