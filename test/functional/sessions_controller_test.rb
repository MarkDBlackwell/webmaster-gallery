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

  test "should render pretty html source" do
    get :new
    see_output
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

  test "get actions should include manage-session div" do
    in_manage_session_div? 'div.manage-session', is_button=false
  end

  test "manage-session div should include session edit button" do
    in_manage_session_div? 'edit'
  end

  test "manage-session div should include session show button" do
    in_manage_session_div? 'show'
  end

  test "manage-session div should include AdminPictures index button" do
    in_manage_session_div? 'admin-pictures-index'
  end

  test "manage-session div should include Pictures index button" do
    in_manage_session_div? 'user-pictures-index'
  end

#-------------
  private

  def in_manage_session_div?(string, button=true)
    s = button ? "div.manage-session > div.#{string} > form.button_to" : string
    [:edit, :new, :show].each do |action|
      session[:logged_in] = :new == action ? nil : true
      get action
      assert_select s, 1, "Action #{action}"
    end
  end

end
