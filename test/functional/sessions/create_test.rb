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
# Already logged in tests:

  test "when already logged in, should..." do
# Log a security warning:
    @controller.logger.expects(:warn).with \
        'W Authenticity-token (or cookie) security failure '\
        '(or program error): '\
        'while session already logged in, '\
        'login attempted from remote IP 0.0.0.0.'
# Not redirect:
    @controller.expects(:redirect_to).never
    pretend_logged_in
    login
# Render nothing:
    assert_nothing_rendered
# Not flash:
    assert_flash_blank
# Log out:
    assert_not_logged_in
  end

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
  private

  def happy_path
    login
  end

  def setup
    pretend_logged_in
    session[:logged_in]=nil
  end

end
