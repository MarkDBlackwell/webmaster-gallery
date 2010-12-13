class SharedEditUpdateSessionsControllerTest < SharedSessionsControllerTest

  private

  def construct_changes(model,operation,count=1)
    expected=case model
    when 'tag'
      s='-name'
      tag_names
    when 'picture'
      s='.png'
      picture_filenames
    end
    case operation
    when 'delet' then changed=expected.pop count
    when 'add'
      changed=series 'three'+s, count
      expected=expected.take(count).concat changed
    end
    [expected,changed]
  end

  def mock_directory_pictures(expected=:all)
    mock_model DirectoryPicture, :filename, expected
  end

  def mock_expected(model,expected)
    other='tag'==model ? [] : :all
    t,p  ='tag'==model ? [expected,other] : [other,expected]
    mock_file_tags          t
    mock_directory_pictures p
    mock_unpaired []
  end

  def mock_file_tags(expected=:all)
    mock_model FileTag, :name, expected
  end

  def mock_model(model,method,expected)
    expected=case
# See ActiveRecord::Base method, '==='. Another way is to use object_id:
    when DirectoryPicture==model then Picture
    when FileTag         ==model then Tag
    end.find(:all).map &method if :all==expected
    model.expects(:find).returns(expected.sort.reverse.
        map{|e| (p=model.new).expects(method).returns e; p} )
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
