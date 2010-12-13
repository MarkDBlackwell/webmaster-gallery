require 'test_helper'

class TagTest < ActiveSupport::TestCase

  test "find methods..." do
# Should find all:
    assert_equal 2, Tag.find(:all).length
  end

end
