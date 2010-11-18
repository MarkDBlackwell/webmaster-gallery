require 'test_helper'

class MessagesApplicationPartialTest < ActionView::TestCase

  test "should render" do
    assert_template :partial => 'application/_messages'
  end

  test "should include one messages div" do
    assert_select 'div.messages', 1
  end

#-------------
  private

  def setup
    render :partial => 'application/messages'
  end

end
