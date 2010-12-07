class SharedSessionsControllerTest < SharedControllerTest
  tests SessionsController

  private

  def construct_added_pictures
    added=['three.png']
    expected=Picture.find(:all).map(&:filename).take(1).concat added
    [expected,added]
  end

  def construct_added_tags
    added=['three-name']
    expected=Tag.find(:all).map(&:name).take(1).concat added
    [expected,added]
  end

  def construct_deleted_pictures
    expected=Picture.find(:all).map &:filename
    deleted=expected.pop 1
    [expected,deleted]
  end

  def construct_deleted_tags
    expected=Tag.find(:all).map &:name
    deleted=expected.pop 1
    [expected,deleted]
  end

  def login(p=nil)
    p=get_password if p.blank?
    set_cookies
    post :create, :password => p
  end

# Working_on

  def mock_directory_pictures(expected)
    expected=Picture.find(:all).map       &:filename if :all==expected
    mock_model expected, DirectoryPicture, :filename
  end

  def mock_directory_pictures_unpaired(expected)
    model=DirectoryPicture
    model.expects(:find_unpaired).returns(expected.
        collect {|e| (p=model.new).expects(:filename).returns e; p} )
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
