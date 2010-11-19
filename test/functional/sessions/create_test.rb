require 'test_helper'

class CreateSessionsControllerTest < SharedSessionsControllerTest
  tests SessionsController

# <- Webmaster logs in.

#-------------
# General tests:

  test "routing" do
    assert_routing({:path => '/session', :method => :post}, :controller =>
        :sessions.to_s, :action => :create.to_s)
  end

#-------------
# Wrong password, not already logged in tests:

  test "should redirect to new on wrong password if not already logged in" do
    login 'example wrong password'
    assert_redirected_to :action => :new
  end

  test "should flash on wrong password if not already logged in" do
    login 'example wrong password'
    assert_equal 'Password incorrect.', flash[:error]
  end

#-------------
# Already logged in tests:

  test "should redirect to edit without asking password if already logged in" do
    pretend_logged_in
    post :create
    assert_redirected_to :action => :edit
  end

  test "should flash so, when already logged in" do
    pretend_logged_in
    post :create
    assert_equal 'You already were logged in.', flash[:notice]
  end

  test "should not flash on wrong password when already logged in" do
    pretend_logged_in
    post :create, :password => 'example wrong password'
    assert_blank flash[:error]
    assert_equal 'You already were logged in.', flash[:notice]
  end

#-------------
# Right password, not already logged in tests:

  test "happy path; should redirect to edit on right password if not "\
       "already logged in" do
    login
    assert_redirected_to :action => :edit
  end

  test "should log in" do
    login
    assert_equal true, session[:logged_in]
  end



  test "logging in should reset the session" do
    session[:something]='something'
    login
    assert_blank session[:something]
  end

  test "shouldn't make a pictures layout file" do
    login
    assert_equal false, pictures_in_layouts_directory?
  end

  test "shouldn't read the webmaster page file" do
    fn="#{Gallery::Application.config.webmaster}/page.html.erb"
    remove_read_permission(fn) {login}
  end

end
