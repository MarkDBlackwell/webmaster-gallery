require 'test_helper'

class ReviewGroupSessionsPartialTest < SharedPartialTest

  test "happy path..." do
# Should render:
    assert_partial
  end

#-------------
  private

  def setup
    render_partial 'sessions/review_group'
  end

end
