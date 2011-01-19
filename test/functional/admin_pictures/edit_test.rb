require 'test_helper'

class EditAdminPicturesControllerTest < SharedAdminPicturesControllerTest
# %%co%%adm%%ed

  test "routing" do # GET
    assert_routing '/admin_pictures/2/edit', :controller =>
        :admin_pictures.to_s, :action => :edit.to_s, :id => '2'
  end

  test_happy_path_response

  test "happy path..." do
    happy_path
# Should render the right template:
    assert_template :single
  end

#    Picture.any_instance.expects(:errors).returns Struct.new(:full_messages).
#        new m
# TODO: add: Should flash the record's errors:
#     assert_equal (m.map{|e| e+'.'}.join ' '), flash[:error]

#-------------
  private

  def happy_path
    pretend_logged_in
    get :edit, :id => pictures(:two).id
  end

end
