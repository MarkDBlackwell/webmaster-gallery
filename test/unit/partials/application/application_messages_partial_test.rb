require 'test_helper'

class ApplicationMessagesPartialTest < ActionView::TestCase

#-------------
# Find method tests:

  test "should include this file" do
#    flunk
  end

  test "should render" do
    render :partial => 'application/messages'
    assert_template :partial => 'application/_messages'
  end

end
