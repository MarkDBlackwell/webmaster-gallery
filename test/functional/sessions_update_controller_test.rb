require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  include SessionsPrivateAllControllerTest

# Update action tests:
# <- Webmaster approves filesystem changes.

#-------------
# General tests:

  test "routing for update" do
    assert_routing({:path => '/session', :method => :put},
      :controller => 'sessions', :action => 'update')
  end

  test "should put update" do
    session[:logged_in]=true
    put 'update'
    assert_response :success
  end

  test "update should redirect to new if not logged in" do
    session[:logged_in]=nil
    put 'update'
    assert_redirected_to :action => 'new'
  end

#-------------
# Already logged in tests:

  test "update should render show" do
    session[:logged_in]=true
    put 'update'
    assert_template 'show'
  end

  test "update should add and remove tags" do
    session[:logged_in]=true
    put 'update'
    assert_equal ['one','three'], Tag.find(:all).collect(&:name).sort
  end

  test "update should add and remove pictures" do
    a=DirectoryPicture.new
    b=DirectoryPicture.new
    a.expects(:filename).returns 'one'
    b.expects(:filename).returns 'three'
    DirectoryPicture.expects(:find).returns [a,b]
    session[:logged_in]=true
    put 'update'
    assert_equal ['one','three'], Picture.find(:all).collect(&:filename).sort
  end

  test "update should expire a cached pictures index page" do
    fn = "#{Rails.root}/public/index.html"
    File.open(fn,'w').close
    session[:logged_in]=true
    put 'update'
    assert_equal false, File.exist?(fn), "#{fn} cache expiration failed."
  end

  test "update should expire a cached pictures index page for a tag" do
    fn = "#{Rails.root}/public/pictures/two-name.html"
    File.open(fn,'w').close
    session[:logged_in]=true
    put 'update'
    assert_equal false, File.exist?(fn), "#{fn} cache expiration failed."
  end

  test "update shouldn't make a pictures layout file" do
    session[:logged_in]=true
    put 'update'
    assert_equal false, pictures_in_layouts_directory?
  end

  test "update shouldn't read the webmaster page file" do
    fn="#{Rails.root}/../gallery-webmaster/page.html.erb"
    session[:logged_in]=true
    remove_read_permission(fn) {put 'update'}
  end

end
