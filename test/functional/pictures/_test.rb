require 'test_helper'

class PicturesControllerTest < SharedControllerTest

  test "filters" do
    assert_no_filter :cookies_required
    assert_filter    :guard_http_method
    assert_no_filter :guard_logged_in
    assert_filter    :verify_authenticity_token
  end

end
