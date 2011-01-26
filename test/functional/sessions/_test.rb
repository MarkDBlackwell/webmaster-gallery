require 'test_helper'

class SessionsControllerTest < SharedSessionsControllerTest
# %%co%%ses

#-------------
# Filter tests:

  test "filters" do
    fresh_state_actions = %w[create destroy new]
    assert_filter       :avoid_links
    assert_filter_skips :find_all_tags,     fresh_state_actions
    assert_filter_skips :get_file_analysis, fresh_state_actions
    assert_filter       :guard_http_method
    assert_filter_skips :guard_logged_in,   fresh_state_actions
    assert_no_filter    :prepare_single
    assert_filter       :verify_authenticity_token
  end

end
