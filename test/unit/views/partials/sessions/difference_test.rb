require 'test_helper'

class DifferenceSessionsPartialTest < SharedPartialTest

  test "happy path..." do
# Should render:
    assert_partial @partial, 1
  end

#-------------
  private

  def setup
    render_partial 'sessions/difference'
  end

end
