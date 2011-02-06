require 'test_helper'

class ShowAdminPicturesControllerTest < SharedAdminPicturesControllerTest
# %%co%%adm%%sh %%adm%%si

  test "routing" do # GET
    assert_routing({:path => '/admin_pictures/2', :method => :get},
        :controller => :admin_pictures.to_s, :action => :show.to_s, :id => '2')
  end

  test_happy_path_response

  test "happy path..." do
    happy_path
# Should render the right template:
    assert_template :single
# Should flash the record's errors:
    assert_flash_errors
# Invoke method, 'render_show':
    assert_flag :edit_allowed
  end

#-------------
  private

  def happy_path
    pretend_logged_in
    get :show, :id => (@record=pictures :two).id
  end

end
