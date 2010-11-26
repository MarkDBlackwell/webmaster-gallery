require 'test_helper'

class CreateSessionsControllerTest < SharedSessionsControllerTest

# <- Webmaster logs in.
  test_happy_path_response :edit

#-------------
# General tests:

  test "routing" do
    assert_routing({:path => '/session', :method => :post}, :controller =>
        :sessions.to_s, :action => :create.to_s)
  end

#-------------
# Wrong password tests:

  test "should redirect to new on wrong password" do
    login 'example wrong password'
    assert_redirected_to :action => :new
  end

  test "should flash on wrong password" do
    login 'example wrong password'
    assert_equal 'Password incorrect.', flash[:error]
  end

#-------------
# Right password tests:

  test "should log in" do
    happy_path
    assert_equal true, session[:logged_in]
  end

  test "logging in should reset the session" do
    session[:something]='something'
    happy_path
    assert_blank session[:something]
  end

  test "logging in shouldn't make a pictures layout file" do
    happy_path
    assert_equal false, pictures_in_layouts_directory?
  end

  test "logging in shouldn't read the webmaster page file" do
    fn="#{Gallery::Application.config.webmaster}/page.html.erb"
    remove_read_permission(fn) {login}
  end

#-------------
  private

  def happy_path
    login
  end

end
