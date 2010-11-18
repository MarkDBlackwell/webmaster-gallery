require 'test_helper'

class AdminPicturesControllerTest < ActionController::TestCase

# All actions tests:

  test "should redirect to sessions new on wrong method" do
    try_wrong_methods [:edit, :index, :show, :update], {:id => '2'},
        :logged_in => true
  end

  test "filters should include find all tags" do
    assert_filter :find_all_tags
  end

  test "filters except index action should include find picture" do
    assert_filter :find_picture, :index
  end

  test "get actions should include session-buttons div" do
# TODO: Add similar tests for styles, messages & action content divs.
# TODO: Or, move to an application layout test.
    [:edit, :index, :show].each do |action|
      pretend_logged_in
#      get action, {:id => pictures(:two).id}, :logged_in => true
      get action, {:id => pictures(:two).id}
      assert_select 'div.session-buttons', 1, "Action #{action}"
      assert_template({:partial => 'application/_buttons'}, "Action #{action}")
    end
  end

end
