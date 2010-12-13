require 'test_helper'

class FileTagTest < ActiveSupport::TestCase

  test "find methods..." do
# Should find all:
#    assert_equal 2, FileTag.find(:all).length
    FileTag.find :all
  end

end
