require 'test_helper'

class ApplicationControllerTest < SharedControllerTest
# %%co%%app

#-------------
# Filter tests:

  test "filters" do
# Keep blank line.
    assert_no_filter    :avoid_links
    assert_filter       :cookies_required
    assert_filter       :find_all_tags
    assert_no_filter    :get_file_analysis
    assert_filter       :guard_http_method
    assert_filter       :guard_logged_in
    assert_no_filter    :prepare_single
    assert_filter       :verify_authenticity_token
  end

end
