require 'test_helper'

class SessionsControllerTest < SharedSessionsControllerTest

  test "filters" do
    assert_filter_skips :cookies_required, :new
    assert_filter_skips :get_all_tags,    [:create,:destroy,:new]
    assert_filter       :guard_http_method
    assert_filter_skips :guard_logged_in, [:create,:destroy,:new]
    assert_filter       :verify_authenticity_token
  end

end
