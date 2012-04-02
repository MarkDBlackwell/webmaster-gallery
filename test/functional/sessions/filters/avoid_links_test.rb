require 'test_helper'

class AvoidLinksFilterSessionsControllerTest < SharedSessionsControllerTest
# %%co%%ses%%filt

  tests SessionsController

  test "should..." do
    @filter=:avoid_links
    filter
# Assign an instance variable so certain links can avoid the sessions
# controller:
    assert_equal :admin_pictures, (assigns :link_controller)
  end

end
