require 'test_helper'

class IndexAdminPicturesControllerTest < SharedAdminPicturesControllerTest
# %%co%%adm%%in

  tests AdminPicturesController

# -> Webmaster views gallery.

  test_routing_tag # GET
  test_happy_path_response

  test "happy path should..." do
    happy_path
# Render the right template:
    assert_template @action
# Show an edit button:
    assert_flag :edit_allowed
# Assign pictures:
    assert_present assigns :pictures
# Assign the right pictures:
    assert_equal PictureSet.get, (assigns :pictures)
  end

#-------------

  def setup
    @controller_name=:admin_pictures
    @action=:index
  end

  private

  def happy_path
    pretend_logged_in
    get @action
  end

end
