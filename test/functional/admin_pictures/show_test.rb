require 'test_helper'

class ShowAdminPicturesControllerTest < SharedAdminPicturesControllerTest

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
  end

#-------------
  private

  def happy_path
    pretend_logged_in
    get :show, :id => pictures(:two).id
  end

end
