require 'test_helper'

class EditAdminPicturesControllerTest < ActionController::TestCase
  tests AdminPicturesController

  test "routing" do
    assert_routing '/admin_pictures/2/edit', :controller =>
        :admin_pictures.to_s, :action => :edit.to_s, :id => '2'
  end

  test "should redirect to /session/new if not logged in" do
    set_cookies
    get :edit, :id => '2'
    assert_redirected_to :controller => :sessions, :action => :new
  end

  test "happy path" do
    pretend_logged_in
    get :edit, :id => pictures(:two).id
    assert_response :success
  end

  test "should render a single picture" do
    pretend_logged_in
    get :edit, :id => pictures(:two).id
    assert_select 'div.picture', 1
    assert_template :partial => 'pictures/_picture', :count => 1
  end

  test "should render the right picture" do
    pretend_logged_in
    picture=pictures(:two)
    id=picture.id
    get :edit, :id => id
    assert_select "div.picture[id=picture_#{id}]"
# TODO: change to test that the pictures/picture partial was rendered with the locals for the right picture.
# Did not work:
#    assert_template :partial => 'pictures/_picture', :locals => {:picture =>
#        picture}
  end

end
