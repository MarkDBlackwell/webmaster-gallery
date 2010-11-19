require 'test_helper'

class AdminPicturesControllerTest < SharedControllerTest

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

  [:edit, :index, :show].each do |action|
    test "get #{action} should render session buttons" do
# TODO: Add similar tests for styles, messages & action content divs.
# TODO: Or, move to an application layout test.
      pretend_logged_in
      get action, :id => pictures(:two).id
      assert_blank_assigns :suppress_buttons
      assert_select 'div.session-buttons', 1
      assert_template :partial => 'application/_buttons'
    end
  end

#-------------
  private

  def assert_blank_assigns(symbol)
    assert_blank assigns(symbol), "@#{symbol}"
  end

end
