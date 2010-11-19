require 'test_helper'

class ShowAdminPicturesControllerTest < ActionController::TestCase
  tests AdminPicturesController

  test "routing" do
    assert_routing({:path => '/admin_pictures/2', :method => :get},
        :controller => :admin_pictures.to_s, :action => :show.to_s, :id => '2')
  end

  test "should redirect to /session/new if not logged in" do
    set_cookies
    get :show, :id => '2'
    assert_redirected_to :controller => :sessions, :action => :new
  end

  test "happy path" do
    happy_path
    assert_response :success
  end

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
# TODO: change to test that the pictures/picture partial was rendered with the locals for the right picture.
# Did not work:
#    assert_template :partial => 'pictures/_picture', :locals => {:picture =>
#        picture}
  end

#-------------
  private

  def happy_path
    pretend_logged_in
    get :show, :id => pictures(:two).id
  end

end
