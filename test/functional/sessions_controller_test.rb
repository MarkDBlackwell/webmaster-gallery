require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  include SessionsPrivateAllControllerTest

# All actions tests:

  test "should include this file" do
#    flunk
  end

  test "verify before_filters" do
    assert Date::today < Date::new(2010,11,5), 'Test unwritten.'
#    class SessionsController
#      before_filter :verify_authenticity_token
#    end
#    puts ActionController::Testing::ClassMethods.before_filters
  end

  test "should redirect to sessions new on wrong method" do
    try_wrong_methods [:create, :destroy, :edit, :new, :show, :update]
  end

  test "sessions should expire after a duration of inactivity" do
    assert_nothing_raised do
      assert_equal 20.minutes, Gallery::Application.config.
          session_options.fetch(:expire_after)
    end
  end

  test "should render pretty html source" do
    get :new
    divs = %w[manage-session edit show admin-pictures-index user-pictures-index
        destroy]
    other = %w[<html><head> <title> <script> <style> <!--Messages-->
        <!--Buttons--> <!--Action\ content--> </body></html>]
    s1 = "<div class=\"#{Regexp.union *divs }\""
    s2 =              "#{Regexp.union *other}"
# Remove any of these divs which are at line beginnings:
    altered1 = response.body.gsub( Regexp.new("\n" + s1), "\n")
    altered2 = response.body.gsub( Regexp.new("\n" + s2), "\n")
    a1 = altered1.clone
    a2 = altered2.clone
# Should not be able to find any of those divs:
    assert_equal true, altered1.gsub!(Regexp.new(s1),'').nil?, a1
    assert_equal true, altered2.gsub!(Regexp.new(s2),'').nil?, a2
  end

  test "should render session buttons" do
    session_buttons_include? 'div.manage-session', false
  end

  test "session buttons should be horizontal" do
    get :new
    assert_select_include? 'head > style[type=text/css]',
        'div.manage-session * {display: inline}'
  end

  test "should render an edit button" do
    session_buttons_include? 'edit'
  end

  test "should render a show button" do
    session_buttons_include? 'show'
  end

  test "should render an AdminPictures index button" do
    session_buttons_include? 'admin-pictures-index'
  end

  test "should render a Pictures index button" do
    session_buttons_include? 'user-pictures-index'
  end

#-------------
  private

  def session_buttons_include?(s, button=true)
    css = ! button ? s : "div.manage-session > div.#{s} > form.button_to"
    [:edit, :new, :show].each do |action|
      session[:logged_in] = :new == action ? nil : true
      get action
      assert_select css, 1, "Action #{action}"
    end
  end

end
