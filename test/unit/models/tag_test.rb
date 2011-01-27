require 'test_helper'

class TagTest < ActiveSupport::TestCase
# %%mo%%tag

  test "find methods should..." do
# Find all:
    assert_equal 2, Tag.find(:all).length
  end

end
