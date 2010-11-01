require 'test_helper'

class AdminPicturesControllerTest < ActionController::TestCase

# Index action tests:

  test "should include this index file" do
#    flunk
  end

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

  test "index pictures should be editable" do
    session[:logged_in]=true
    get :index
    assert_not_nil assigns(:editable)
  end

  test "index should render the right template" do
    assert Date::today < Date::new(2010,11,7), 'Test unwritten.'
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

  test "index should render a styling suggestion for a list of all tags" do
    session[:logged_in]=true
    get :index
    assert_select_include? 'head > style[type=text/css]',
        'div.all-tags * {display: inline}'
  end

  test "index should render a gallery" do
    session[:logged_in]=true
    get :index
    assert_select 'div.gallery'
  end

  test "index should render a gallery styling suggestion" do
    session[:logged_in]=true
    get :index
    assert_select_include? 'head > style[type=text/css]',
        'div.picture {display: inline-block}'
  end

end
