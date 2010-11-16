require 'test_helper'
should_include_this_file

class TagTest < ActiveSupport::TestCase

#-------------
# Find method tests:

  test "find all" do
    assert_equal 2, Tag.find(:all).length
  end

end
