require 'test_helper'

class TagTest < ActiveSupport::TestCase

#-------------
# Find method tests:

  test "should include this file" do
#    flunk
  end

  test "find all" do
    assert Date::today < Date::new(2010,11,2), 'Test unwritten.'
#    assert_equal 2, Tag.find(:all).length
  end

end
