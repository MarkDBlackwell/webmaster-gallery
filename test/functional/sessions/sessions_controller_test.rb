require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  include SessionsPrivateAllControllerTest

# All actions tests:

  test "should include this file" do
#    flunk
  end

  test "guard logged in should skip some actions" do
    assert_filter :guard_logged_in, [:create,:destroy,:new]
  end

  test "should redirect to sessions new on wrong method" do
    try_wrong_methods [:create, :destroy, :edit, :new, :show, :update]
  end

  test "sessions should expire after a duration of inactivity" do
    assert_nothing_raised do
      assert_equal 20.minutes, Gallery::Application.config.session_options.
          fetch(:expire_after)
    end
  end

  test "webmaster directory location should be configured" do
    assert_equal Gallery::Application.config.webmaster,
        "#{Rails.root}/test/fixtures/files/webmaster"
  end

  test "should render pretty html source" do
# TODO: move this to application controller, or split this into buttons, styles, etc.? 
    get :new
    divs = %w[manage-session edit show admin-pictures-index user-pictures-index
        destroy]
    other = %w[<html><head> <title> <script> <style> <!--Styles-->
        <!--Messages--> <!--Buttons--> <!--Action\ content--> </body></html>]
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

  test "should render session buttons" do
# TODO: change to test that the application/buttons partial was rendered once.
    [:edit, :show].each do |action|
      session[:logged_in]=true
      get action
      assert_select 'div.manage-session', 1, "Action #{action}"
    end
  end

end
