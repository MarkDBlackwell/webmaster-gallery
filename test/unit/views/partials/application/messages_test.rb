require 'test_helper'

class MessagesApplicationPartialTest < SharedViewTest

  test "should render pretty html source" do
    check_pretty_html_source 'Messages', %w[messages notice notice\ error]
  end

  test "messages partial" do
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
