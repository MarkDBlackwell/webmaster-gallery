require 'test_helper'

class SessionsControllerTest < SharedSessionsControllerTest

# All actions tests:

  test "guard logged in should skip some actions" do
    assert_filter :guard_logged_in, [:create,:destroy,:new]
  end

  test "webmaster directory location should be configured" do
    assert_equal Gallery::Application.config.webmaster,
        "#{Rails.root}/test/fixtures/files/webmaster"
  end

  test "sessions should expire after a duration of inactivity" do
    assert_nothing_raised do
      assert_equal 20.minutes, Gallery::Application.config.session_options.
          fetch(:expire_after)
    end
  end

  test "should redirect to sessions new on wrong http method" do
    try_wrong_methods [:create, :destroy, :edit, :new, :show, :update]
  end

#-------------
# Cookies blocked tests:

  test "should flash if cookies (session store) blocked while already "\
       "logged in" do
    session[:logged_in]=true
    request.cookies.clear
    post :create, :password => get_password
    assert_select 'div.error', 'Cookies required, or session timed out.'
  end

  test "should not flash so, if cookies not blocked" do
    login
    assert_select 'div.notice', 0
    assert_select 'div.error', 0
  end

  test "should render session buttons" do
    [:edit,:show].each_with_index do |action,i|
      pretend_logged_in
      get action
      assert_select 'div.session-buttons', 1, "Action #{action}"
      assert_template({:partial => 'application/_buttons', :count => i + 1},
          "Action #{action}") # Count mounts up.
    end
  end

  test "should render pretty html source" do
# TODO: move this to application controller, or split this into buttons, styles, etc.? 
    set_cookies
    get :new
    divs = %w[
admin-pictures-index  destroy  edit  session-buttons  show  user-pictures-index
        ]
    other = %w[
<!--Action\ content-->  </body></html>  <html><head>  <!--Messages-->  <script> 
<!--Session\ buttons-->  <style>  <!--Styles-->  <title>
        ]
    s1 = "<div class=\"#{Regexp.union *divs }\""
    s2 =              "#{Regexp.union *other}"
# Remove any of these divs which are at line beginnings:
    altered1 = response.body.gsub( Regexp.new("\n" + s1), "\n")
    altered2 = response.body.gsub( Regexp.new("\n" + s2), "\n")
    a1 = altered1.clone
    a2 = altered2.clone
# Should not be able to find any of those divs:
    assert altered1.gsub!(Regexp.new(s1),'').blank?, (see_output(a1);'Div class=')
    assert altered2.gsub!(Regexp.new(s2),'').blank?, (see_output(a2);'Other')
  end

end
