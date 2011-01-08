require 'test_helper'

class PictureTest < ActiveSupport::TestCase

  test "find methods..." do
# Should find all:
    assert_equal 2, Picture.find(:all).length
# Should find database problems:
    assert_equal 2, Picture.find_database_problems.length
  end

end
