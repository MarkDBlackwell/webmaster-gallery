require 'test_helper'

class CreateSessionsControllerTest < SharedSessionsControllerTest
# %%co%%ses%%cr

# <- Webmaster logs in.

  test "routing" do # POST
    assert_routing({:path => '/session', :method => :post}, :controller =>
        :sessions.to_s, :action => :create.to_s)
  end

  test_happy_path_response :edit

#-------------
# Wrong password tests:

  test "when password wrong, should..." do
    login 'example wrong password'
# Redirect to new:
    assert_redirected_to :action => :new
# Flash:
    assert_equal 'Password incorrect.', flash[:error]
  end

#-------------
# Right password tests:

  test "when password right, logging in should..." do
    kv=:something
    session[kv]=kv
# Not read the webmaster page file:
    remove_read_permission(App.webmaster.join 'page.html.erb'){happy_path}
# Succeed:
    assert_logged_in
# Reset the session:
    assert_blank session[kv]
# Not make a pictures layout file:
    assert_equal false, pictures_in_layouts_directory?
  end

#-------------

  def setup
    pretend_logged_in
    session[:logged_in]=nil
  end

  private

  def happy_path
    login
  end

end
