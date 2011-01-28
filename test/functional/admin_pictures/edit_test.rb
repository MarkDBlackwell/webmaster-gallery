require 'test_helper'

class EditAdminPicturesControllerTest < SharedAdminPicturesControllerTest
# %%co%%adm%%ed %%adm%%si

  test "routing" do # GET
    assert_routing '/admin_pictures/2/edit', :controller =>
        :admin_pictures.to_s, :action => :edit.to_s, :id => '2'
  end

  test_happy_path_response

  test "happy path should..." do
    happy_path
# Render the right template:
    assert_template :single
# Find the right record:
    assert_equal @record.id, assigns(:picture).id
# Flash the record's errors:
    assert_flash_errors
# Show attribute labels:
    assert_flag :show_labels,
# Allow editing:
                :edit_fields
  end

#-------------
  private

  def happy_path
    pretend_logged_in
    get :edit, :id => (@record=pictures :two).id
  end

end
