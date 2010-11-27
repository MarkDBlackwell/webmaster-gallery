require 'test_helper'

class AdminPicturesControllerTest < SharedAdminPicturesControllerTest

  ACTIONS=[:edit, :index, :show, :update]
  test_cookies_blocked ACTIONS
  test_if_not_logged_in_redirect_from  ACTIONS
  test_should_render_session_buttons ACTIONS - [:update]
  test_wrong_http_methods ACTIONS

  test "alert me" do
# When rendering a partial picks up the application layout:
    f="#{Rails.root}/app/views/admin_pictures/_single.html.erb"
    FileUtils.touch f
    @controller.expects(:template).returns(:partial)
    pretend_logged_in
    get :show, :id => pictures(:two).id # For example.
    assert_select 'div.action-content', false
    FileUtils.rm f
  end

  test "filters should include find all tags" do
    assert_filter :find_all_tags
  end

  test "filters should include find picture except index action" do
    assert_filter :find_picture, :index
  end

end
