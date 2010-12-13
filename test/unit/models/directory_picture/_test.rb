require 'test_helper'

class DirectoryPictureTest < ActiveSupport::TestCase

  test "find methods..." do
# Should find all:
#    assert_equal 2, DirectoryPicture.find(:all).length
    DirectoryPicture.find :all
  end

end
