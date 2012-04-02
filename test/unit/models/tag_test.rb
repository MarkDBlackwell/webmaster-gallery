require 'test_helper'

class TagTest < SharedModelTest
# %%mo%%tag

  test "..." do
# Should include validations for...:
# Uniqueness:
    assert_validates_uniqueness_of %w[id name]
# Presence:
    assert_validates_presence_of 'name'
# And...:
# The right number of records should be obtained using methods...:
# Find all:
    assert_equal 3, @model.count
# And...:
# Associations should...:
# Have the right number of pictures:
    id=(r=@record).id
    assert_equal Picture.count, r.pictures.length
# When pictures are deleted, should...:
# Adjust collections:
    assert_difference('r.pictures(reload=true).length', -1){pictures(:one).
        destroy}
# When deleted, should:
# Keep associated pictures:
    assert_no_difference('Picture.count'){r.destroy}
# Delete associated picture-tag joins (tests :dependent => :destroy):
##    assert_blank PictureTagJoin.find :one_two
    assert_blank PictureTagJoin.where ['tag_id     IN (?)', id]
  end

#-------------

  def setup
    @model=Tag
    @record=tags :two
  end

end
