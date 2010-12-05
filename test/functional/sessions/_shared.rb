class SharedSessionsControllerTest < SharedControllerTest
  tests SessionsController

  private

  def login(p=nil)
    p=get_password if p.blank?
    set_cookies
    post :create, :password => p
  end

# Working_on

  def mock_directory_pictures(expected)
    mock_model expected, DirectoryPicture, :filename
  end

  def mock_file_tags(expected)
    expected=Tag.find(:all).map  &:name if :all==expected
    mock_model expected, FileTag, :name
  end

  def mock_model(expected,model,method)
    model.expects(:find).returns(expected.
        collect {|e| (p=model.new).expects(method).returns e; p} )
  end

  def pictures_in_layouts_directory?
    App.root.join(*%w[app views layouts pictures.html.erb]).exist?
  end

  def remove_read_permission(path)
    mode=path.stat.mode
    path.chmod(mode ^ 0444) # Remove read permissions.
    begin assert_nothing_raised {yield}
    ensure path.chmod mode end
  end

end
