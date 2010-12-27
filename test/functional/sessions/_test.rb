require 'test_helper'

class SessionsControllerTest < SharedSessionsControllerTest

  test "filters" do
    assert_filter       :avoid_links
    assert_filter_skips :cookies_required,  :new
    assert_filter_skips :find_all_tags,     [:create,:destroy,:new]
    assert_filter_skips :get_file_analysis, [:create,:destroy,:new]
    assert_no_filter    :get_single
    assert_filter       :guard_http_method
    assert_filter_skips :guard_logged_in,   [:create,:destroy,:new]
    assert_filter       :verify_authenticity_token
  end

  test "avoid_links filter should..." do
    @controller.send :avoid_links
# Assign an instance variable so certain links can avoid the sessions
# controller:
    assert_equal :admin_pictures, assigns(:use_controller)
  end

end
