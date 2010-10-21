require 'test_helper'

class AdminPicturesControllerTest < ActionController::TestCase

#-------------
# All actions tests:

  test "verify before_filters" do
    assert Date::today < Date::new(2010,10,29), 'Test unwritten.'
#    class AdminPicturesController
#      before_filter :verify_authenticity_token
#    end
#    puts ActionController::Testing::ClassMethods.before_filters
  end

  test "should redirect to new on wrong method" do
# Reference: 'ActionController - PROPFIND and other HTTP request methods':
# at http://railsforum.com/viewtopic.php?id=30137

    Restful = Struct.new(:action, :method)
    [   Restful.new(     :edit,   'get'),
        Restful.new(     :index,  'get'),
        Restful.new(     :show,   'get'),
        Restful.new(     :update, 'put'),
        ].each do |proper|
      (ActionController::Request::HTTP_METHODS - [proper[:method]] ).
          each do |bad_method|
        process proper[:action], {:id => '2'}, {:logged_in => true}, nil,
            bad_method
        assert_redirected_to({:controller => :sessions, :action => :new},
            "Action #{proper[:action]}, method #{bad_method}.")
      end
    end
  end

#-------------
# Index action tests:

  test "routing /admin_pictures" do
    assert_routing '/admin_pictures', :controller => 'admin_pictures',
      :action => 'index'
  end

  test "routing /admin_pictures/some_tag" do
    assert_routing '/admin_pictures/some_tag',
      :controller => 'admin_pictures', :action => 'index', :tag => 'some_tag'
  end

  test "should get index" do
    session[:logged_in]=true
    get :index
    assert_response :success
  end

  test "should redirect to /session/new if not logged in" do
    session[:logged_in]=nil
    get :index
    assert_redirected_to :controller => :sessions, :action => :new
  end

#-------------
# Show action tests:

  test "routing get /admin_pictures/2" do
    assert_routing({:path => '/admin_pictures/2', :method => 'get'},
        :controller => 'admin_pictures', :action => 'show', :id => '2')
  end

  test "should get show" do
    session[:logged_in]=true
    get :show, :id => '2'
    assert_response :success
  end

#-------------
# Edit action tests:

  test "should get edit" do
    session[:logged_in]=true
    get :edit, :id => '2'
    assert_response :success
  end

#-------------
# Update action tests:

  test "routing put /admin_pictures/2" do
    assert_routing({:path => '/admin_pictures/2', :method => 'put'},
        :controller => 'admin_pictures', :action => 'update', :id => '2')
  end

  test "should put update" do
    session[:logged_in]=true
    put :update, :id => '2'
    assert_response :success
  end

end
