require 'test_helper'

class AvoidLinksFilterSessionsControllerTest < SharedSessionsControllerTest

  test "should..." do
    @controller.send :avoid_links
# Assign an instance variable so certain links can avoid the sessions
# controller:
    assert_equal :admin_pictures, assigns(:use_controller)
  end

end
