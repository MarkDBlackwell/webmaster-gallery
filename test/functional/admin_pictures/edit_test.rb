require 'test_helper'

class EditAdminPicturesControllerTest < SharedAdminPicturesControllerTest

  test "routing" do
    assert_routing '/admin_pictures/2/edit', :controller =>
        :admin_pictures.to_s, :action => :edit.to_s, :id => '2'
  end

  test_happy_path_response

  test "should render a single picture" do
    happy_path
    assert_select 'div.picture', 1
    assert_template :partial => 'pictures/_picture', :count => 1
  end

  test "should render the right picture" do
    picture=pictures(:two)
    id=picture.id
    happy_path
    assert_select "div.picture[id=picture_#{id}]"
  end

  test "alert me when testing a partial was rendered with the right locals "\
       "works: when a bug in lines 99-102 of assert_template is fixed" do
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
