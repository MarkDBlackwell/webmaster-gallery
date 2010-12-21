require 'test_helper'

class PicturesControllerTest < SharedControllerTest

  test "filters" do
    assert_no_filter :avoid_links
    assert_no_filter :cookies_required
    assert_filter    :find_all_tags
    assert_no_filter :get_single
    assert_filter    :guard_http_method
    assert_no_filter :guard_logged_in
    assert_filter    :verify_authenticity_token
  end

end
