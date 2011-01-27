require 'test_helper'

class TagTest < ActiveSupport::TestCase
# %%mo%%tag

# working on %%mo%%pic

  test "..." do
# Find all should...:
# Find the right number of records:
    assert_equal 2, Tag.find(:all).length
# Associations should...:
# Have the right number of pictures:
    r=tags :two
    assert_equal Picture.find(:all).length, r.pictures.length
# Adjust when pictures are deleted:
    assert_difference('r.pictures(true).length', -1) {pictures(:one).destroy}
# Not automatically delete associated pictures:
    assert_no_difference('Picture.find(:all).length'){r.destroy}
  end

end
