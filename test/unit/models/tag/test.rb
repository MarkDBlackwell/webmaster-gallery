require 'test_helper'

class TagTest < ActiveSupport::TestCase

#-------------
# Find method tests:

  test "should include this file" do
#    flunk
  end

  test "find all" do
    assert_equal 2, Tag.find(:all).length
  end

end
