require 'test_helper'

class DirectoryPictureTest < ActiveSupport::TestCase

  test "Directory Picture should..." do
# Use the right directory:
    assert_equal (App.root.join *%w[public images gallery]),
        (DirectoryPicture.send :gallery_directory)
  end

  test "basic directory..." do
    mock_gallery_directory 'basic'
# Find all should give all files:
    fa=DirectoryPicture.find :all
    assert_equal 7, fa.length
# Find unpaired should give all files:
    fu=DirectoryPicture.find_unpaired_names
    assert_equal 7, fu.length
  end

#-------------
  private

  def mock_gallery_directory(s)
    DirectoryPicture.expects(:gallery_directory).at_least_once.returns(@tests.
        join s)
  end

  def setup
    @tests=App.root.join *%w[test fixtures files directory_pictures gallery
        test]
  end

end
