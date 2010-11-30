require 'test_helper'

class MessagesApplicationPartialTest < SharedViewTest

  test "happy path..." do
# Should render pretty html source:
    check_pretty_html_source 'Messages', %w[messages notice notice\ error]
# Should render:
    assert_template :partial => 'application/_messages', :count => 1
# Should include one messages div:
    assert_select 'div.messages', 1
  end

#-------------
  private

  def setup
    [:error,:notice].each {|e| flash.now[e]="some #{e}" }
    render :partial => 'application/messages'
  end

end
