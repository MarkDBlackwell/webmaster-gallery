require 'test_helper'

class SessionsControllerTest < SharedSessionsControllerTest

  ACTIONS=[:create, :destroy, :edit, :new, :show, :update]
  test_cookies_blocked ACTIONS
  test_if_not_logged_in_redirect_from  ACTIONS - [:create, :new]
  test_should_render_session_buttons ACTIONS - [:create,:destroy,:new,:update]
  test_wrong_http_methods ACTIONS

  test "guard logged in should skip some actions" do
    assert_filter :guard_logged_in, [:create,:destroy,:new]
  end

  test "should render pretty html source" do
# TODO: maybe move this to application view test.
# TODO: maybe split this into buttons, styles partials, etc.
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
