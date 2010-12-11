require 'test_helper'

class CreateSessionsControllerTest < SharedSessionsControllerTest

# <- Webmaster logs in.

#-------------
# General tests:

  test "routing" do # POST
    assert_routing({:path => '/session', :method => :post}, :controller =>
        :sessions.to_s, :action => :create.to_s)
  end

  test_happy_path_response :edit

#-------------
# Wrong password tests:

  test "when password wrong..." do
    login 'example wrong password'
# Should redirect to new:
    assert_redirected_to :action => :new
# Should flash:
    assert_equal 'Password incorrect.', flash[:error]
  end

#-------------
# Right password tests:

  test "when password right, logging in..." do
    s=:something
    session[s]=s
    login
# Should succeed:
    assert_equal true, session[:logged_in]
# Should reset the session:
    assert_blank session[s]
# Shouldn't make a pictures layout file:
    assert_equal false, pictures_in_layouts_directory?
  end

  test "logging in shouldn't read the webmaster page file" do
    f=App.webmaster.join 'page.html.erb'
    remove_read_permission(f){login}
  end

#-------------
  private

  def happy_path
    login
  end

end
