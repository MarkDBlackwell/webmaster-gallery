class SharedEditUpdateSessionsControllerTest < SharedSessionsControllerTest

  private

  def construct_added_pictures(count=1)
    added=series('three.png',count).reverse
    expected=picture_filenames.take(count).concat(added).sort.reverse
    [expected,added]
  end

  def construct_added_tags(count=1)
    added=series('three-name',count).reverse
    expected=tag_names.take(count).concat(added).sort.reverse
    [expected,added]
  end

  def construct_deleted_pictures(count=1)
    expected=picture_filenames
    deleted=expected.pop(count).reverse
    expected=expected.reverse
    [expected,deleted]
  end

  def construct_deleted_tags(count=1)
    expected=tag_names
    deleted=expected.pop(count).reverse
    expected=expected.reverse
    [expected,deleted]
  end

  def mock_directory_pictures(expected)
    expected=picture_filenames.reverse if :all==expected
    mock_model expected, DirectoryPicture, :filename
  end

  def mock_file_tags(expected)
    expected=tag_names.reverse if :all==expected
    mock_model expected, FileTag, :name
  end

  def mock_model(expected,model,method)
    model.expects(:find).returns(
        expected.collect {|e| (p=model.new).expects(method).returns e; p} )
  end

  def mock_unpaired(expected)
    DirectoryPicture.expects(:find_unpaired).returns expected
  end

  def picture_filenames
    n=:filename
    Picture.order(n).find(:all).map &n
  end

  def series(start,count=1)
    o=object=nil
    Array.new(count){o=o.blank? ? start : o.succ}
  end

  def tag_names
    n=:name
    Tag.order(n).find(:all).map &n
  end

end
