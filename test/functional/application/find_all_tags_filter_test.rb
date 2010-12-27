require 'test_helper'

class FindAllTagsFilterApplicationControllerTest <
    SharedApplicationControllerTest

  test "should..." do
    @controller.send :find_all_tags
# Assign an instance variable for all the tags.
    assert_equal Tag.find(:all), assigns(:all_tags)
  end

end
