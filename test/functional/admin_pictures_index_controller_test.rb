require 'test_helper'

class AdminPicturesControllerTest < ActionController::TestCase

# Index action tests:

  test "routing get /admin_pictures" do
    assert_routing '/admin_pictures', :controller => 'admin_pictures',
      :action => 'index'
  end

  test "routing get /admin_pictures/some_tag" do
    assert_routing '/admin_pictures/some_tag',
      :controller => 'admin_pictures', :action => 'index', :tag => 'some_tag'
  end

  test "index should redirect to /session/new if not logged in" do
    session[:logged_in]=nil
    get :index
    assert_redirected_to :controller => :sessions, :action => :new
  end

  test "should get index if logged in" do
    session[:logged_in]=true
    get :index
    assert_response :success
  end

  test "index should be editable" do
    session[:logged_in]=true
    get :index
    assert_not_nil assigns(:editable)
  end

  test "index should render the right template" do
    assert Date::today < Date::new(2010,10,29), 'Test unwritten.'
#    session[:logged_in]=true
#    get :index
#    list = ['gallery','picture','tags'].collect do |e|
#        ['','pictures/'].collect {|prefix| "#{prefix}_#{e}"}
#    end.flatten!
#    list = ['_picture','pictures/_gallery','_tags','pictures/_picture',
#       '_gallery','pictures/_tags']
#puts list
#    assert_template :controller => :admin_pictures, :action => :index,
#        :partial => list
  end

  test "index should render a list of all tags" do
    session[:logged_in]=true
    get :index
    assert_select 'div.all-tags'
  end

  test "index should render a gallery" do
    session[:logged_in]=true
    get :index
    assert_select 'div.gallery'
  end

end
