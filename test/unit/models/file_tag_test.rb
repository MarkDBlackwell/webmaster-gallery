require 'test_helper'

class FileTagTest < ActiveSupport::TestCase
# %%mo%%ftag

  test "..." do
# Find all should...:
# Give the right collection:
    a=@model.all
    assert_equal 2, a.length
    assert_equal %w[one three], (a.map &:name)
# Find bad names should...:
# Give the right collection:
    b=@model.find_bad_names
    assert_equal [], b
# Find methods shouldn't re-read the file:
    @model.expects(:read).never
    @model.all
    @model.find_bad_names
  end

#-------------

  def setup
    @model=FileTag
    @model.read
  end

end
