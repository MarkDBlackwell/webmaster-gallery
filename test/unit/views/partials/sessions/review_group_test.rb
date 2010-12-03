require 'test_helper'

class ReviewGroupSessionsPartialTest < SharedPartialTest

  test "happy path..." do
# Should render:
    assert_partial
    assert_select 'div.review-group', 1
  end

#-------------
  private

  def setup
    render_partial 'sessions/review_group'
  end

end
