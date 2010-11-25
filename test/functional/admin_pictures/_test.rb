require 'test_helper'

class AdminPicturesControllerTest < SharedAdminPicturesControllerTest

# All actions tests:

  test "alert me when rendering a partial picks up the application layout" do
    f="#{Rails.root}/app/views/admin_pictures/_single.html.erb"
    FileUtils.touch f
    @controller.expects(:template).returns(:partial)
    pretend_logged_in
    get :show, :id => pictures(:two).id
    assert_select 'div.action-content', false
    FileUtils.rm f
  end

  [:edit, :index, :show, :update].each do |action|
    test "#{action} should redirect to sessions new on wrong method" do
      try_wrong_methods action, {:id => '2'}, :logged_in => true
    end
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
      assert_template :partial => 'application/_buttons', :count => 1
    end
  end

#-------------
  private

  def assert_blank_assigns(symbol)
    assert_blank assigns(symbol), "@#{symbol}"
  end

end
