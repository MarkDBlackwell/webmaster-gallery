require 'test_helper'

class FindAllTagsFilterApplicationControllerTest <
    SharedApplicationControllerTest
# %%co%%app%%filt

  tests ApplicationController

  test "should..." do
    @filter=:find_all_tags
    filter
# Assign an instance variable for all the tags.
    assert_equal Tag.all, (assigns :all_tags)
  end

end
