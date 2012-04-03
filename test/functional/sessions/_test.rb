require 'test_helper'

class SessionsControllerTest < SharedSessionsControllerTest
# %%co%%ses

  tests SessionsController

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

#-------------
# Alert-me tests:

  test "alert me, when..." do
    @controller.params['action']='create'
    session[:logged_in]=true
    e=nil
    assert_raises RuntimeError do
# Rails enables these semantics:
      begin @controller.send :toggle_login
      rescue RuntimeError => e; raise e end
    end
    sw = 'ActionController::RackDelegation#status= '\
                  'delegated to @_response.status=, but @_response is nil:'
    assert e.to_s.start_with?(sw), e.to_s
  end

end
