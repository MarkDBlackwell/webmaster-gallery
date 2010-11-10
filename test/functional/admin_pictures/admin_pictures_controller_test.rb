require 'test_helper'

class AdminPicturesControllerTest < ActionController::TestCase

# All actions tests:

  test "should include this file" do
#    flunk
  end

  test "should redirect to sessions new on wrong method" do
    try_wrong_methods( [:edit, :index, :show, :update], {:id => '2'},
        :logged_in => true)
  end

  test "get actions should include manage-session div" do
# TODO: change to test that the partial was rendered.
#    render :partial => 'application/buttons'
# TODO: Add similar tests for styles, messages & action content divs.
# TODO: Or, move to an application layout test.

    [:edit, :index, :show].each do |action|
      session[:logged_in]=true
      get(action, {:id => pictures(:two).id}, :logged_in => true)
      assert_select 'div.manage-session', 1, "Action #{action}"
    end
  end

end
