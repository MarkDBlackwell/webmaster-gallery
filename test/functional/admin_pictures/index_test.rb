require 'test_helper'

class IndexAdminPicturesControllerTest < SharedAdminPicturesControllerTest
# %%co%%adm%%in

# -> Webmaster views gallery.

  test_routing_tag # GET
  test_happy_path_response

  test "happy path..." do
    happy_path
# Should render the right template:
    assert_template @action
# Gallery pictures should be editable:
    assert_present assigns :editable
  end

#-------------
  private

  def happy_path
    pretend_logged_in
    get @action
  end

  def setup
    @controller_name=:admin_pictures.to_s
    @action=:index
  end

end
