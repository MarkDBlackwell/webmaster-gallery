class SharedEditUpdateSessionsControllerTest < SharedSessionsControllerTest

  private

  def construct_added_pictures(count=1)
    added=series 'three.png', count
    expected=picture_filenames.take(count).concat added
    [expected,added]
  end

  def construct_added_tags(count=1)
    added=series 'three-name', count
    expected=tag_names.take(count).concat added
    [expected,added]
  end

  def construct_deleted_pictures(count=1)
    expected=picture_filenames.sort
    deleted=expected.pop count
    [expected,deleted]
  end

  def construct_deleted_tags(count=1)
    expected=tag_names
    deleted=expected.pop count
    [expected,deleted]
  end

  def mock_directory_pictures(expected)
    expected=picture_filenames if :all==expected
    mock_model expected, DirectoryPicture, :filename
  end

  def mock_file_tags(expected)
    expected=tag_names if :all==expected
    mock_model expected, FileTag, :name
  end

  def mock_model(expected,model,method)
    model.expects(:find).returns(expected.sort.reverse.
        collect{|e| (p=model.new).expects(method).returns e; p} )
  end

  def mock_unpaired(expected)
    DirectoryPicture.expects(:find_unpaired).returns expected.sort.reverse
  end

  def picture_filenames
    n=:filename
    Picture.find(:all).map &n
  end

  def series(start,count=1)
    o=object=nil
    Array.new(count){o=o.blank? ? start : o.succ}
  end

  def tag_names
    n=:name
    Tag.find(:all).map &n
  end

end
