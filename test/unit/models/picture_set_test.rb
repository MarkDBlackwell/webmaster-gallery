require 'test_helper'

class PictureSetTest < ActiveSupport::TestCase
# %%mo%%ps

  test "should..." do
# Have pictures in the right order: 
    fields     = %w[  year  weight  sequence ]
    directions = %w[  DESC  ASC     DESC     ]
    by=fields.zip(directions).map{|f,d| 'ASC'==d ? f:(f+' '+d)}.join ', '
    assert_equal by, @model.order
  end

#-------------
  private

  def setup
    @model=PictureSet
  end

end
