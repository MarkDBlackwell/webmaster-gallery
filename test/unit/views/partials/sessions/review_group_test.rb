require 'test_helper'

class ReviewGroupSessionsPartialTest < SharedPartialTest

  test "happy path..." do
# Should render:
    assert_partial
    assert_select 'div.review-group', 1 do
      assert_select 'div.review-group > div.review-message', 1
    end
  end

#-------------
  private

  def setup
    r=Struct.new(:list,:message).new(Picture.find(:all),'message')
    render_partial 'sessions/review_group', :review_group => r
  end

end
