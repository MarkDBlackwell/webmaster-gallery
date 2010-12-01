require 'test_helper'

class AdminPicturesControllerTest < SharedAdminPicturesControllerTest

#-------------
# All actions tests:

  test "filters" do
    assert_filter :cookies_required
    assert_filter :find_all_tags
    assert_filter_skips :find_picture, :index
    assert_filter :guard_http_method
    assert_filter :guard_logged_in
    assert_filter :verify_authenticity_token
  end

#-------------
# Alert me tests:

  test "alert me (show)..." do
# When rendering a partial picks up the application layout:
    f=App.root.join *%w[app views admin_pictures _single.html.erb]
    FileUtils.touch f
    @controller.expects(:template).returns(:partial)
    pretend_logged_in
    get :show, :id => pictures(:two).id # For example.
    assert_select 'div.action-content', false
    f.delete
  end

  test "alert me (index)..." do
    pretend_logged_in
    get :index
# When Rails enables these semantics:
    assert_template :index, :count => 0
    assert_template :index, 0
  end

end
