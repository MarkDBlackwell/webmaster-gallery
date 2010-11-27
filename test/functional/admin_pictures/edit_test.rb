require 'test_helper'

class EditAdminPicturesControllerTest < SharedAdminPicturesControllerTest

  test_happy_path_response

  test "routing" do
    assert_routing '/admin_pictures/2/edit', :controller =>
        :admin_pictures.to_s, :action => :edit.to_s, :id => '2'
  end

  test "alert me when testing works, that a partial was rendered with the "\
       "right locals: when a bug in lines 99-102 of assert_template is fixed" do
    picture=pictures(:two)
    happy_path
    assert_raise NoMethodError do
      assert_template :partial => 'pictures/_picture', :locals => {:picture =>
          picture}
    end
  end

#-------------
  private

  def happy_path
    pretend_logged_in
    get :edit, :id => pictures(:two).id
  end

end
